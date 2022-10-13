defmodule Circlex.Emulator.Logic.TransferLogic do
  import Circlex.Emulator.Logic.LogicUtil

  alias Circlex.Emulator.Logic.WalletLogic
  alias Circlex.Struct.{Amount, Transfer}

  @usdc_decimals 6

  def get_transfer(transfers, transfer_id) do
    find(transfers, fn %Transfer{id: id} -> id == transfer_id end)
  end

  def add_transfer(transfers, transfer) do
    {:ok, [transfer | transfers]}
  end

  def update_transfer(transfers, transfer_id, f) do
    update(transfers, fn %Transfer{id: id} -> id == transfer_id end, f)
  end

  def process_transfer(st = %{transfers: transfers, wallets: wallets}, transfer_id) do
    {:ok, transfer} = get_transfer(transfers, transfer_id)

    {wallets, transfers} =
      case {transfer.source.type, transfer.destination.type} do
        {:blockchain, :wallet} ->
          {:ok, wallet} = WalletLogic.get_wallet(wallets, transfer.destination.id)
          {:ok, wallets} = WalletLogic.update_balance(wallets, wallet.wallet_id, transfer.amount)

          {:ok, transfers} =
            update_transfer(transfers, transfer.id, fn t -> %{t | status: "complete"} end)

          {wallets, transfers}

        {:wallet, :wallet} ->
          {:ok, source_wallet} = WalletLogic.get_wallet(wallets, transfer.source.id)
          {:ok, destination_wallet} = WalletLogic.get_wallet(wallets, transfer.destination.id)

          {:ok, wallets} =
            WalletLogic.update_balance(
              wallets,
              source_wallet.wallet_id,
              Amount.negate(transfer.amount)
            )

          {:ok, wallets} =
            WalletLogic.update_balance(wallets, destination_wallet.wallet_id, transfer.amount)

          {:ok, transfers} =
            update_transfer(transfers, transfer.id, fn t -> %{t | status: "complete"} end)

          {wallets, transfers}

        {:wallet, :blockchain} ->
          {:ok, wallet} = WalletLogic.get_wallet(wallets, transfer.source.id)

          {:ok, wallets} =
            WalletLogic.update_balance(wallets, wallet.wallet_id, Amount.negate(transfer.amount))

          to_addr = :binary.decode_unsigned(Signet.Util.decode_hex!(transfer.destination.address))
          wei_amount = Amount.to_wei(transfer.amount, @usdc_decimals)

          IO.inspect(Process.get(:signer_proc), label: "***ok***")
          IO.inspect(Signet.Signer.address(Process.get(:signer_proc)) |> Signet.Util.encode_hex(), label: "*****Address****")
          {:ok, trx_id} =
            Signet.RPC.execute_trx(
              Circlex.Emulator.usdc_address(),
              {"transfer(address,uint256)", [to_addr, wei_amount]},
              gas_price: {15, :gwei},
              value: 0,
              signer: Process.get(:signer_proc)
            )

            {:ok, transfers} =
            update_transfer(transfers, transfer.id, fn t ->
              # TODO: Wait for the tx to complete before "complete"
              %{t | transaction_hash: Signet.Util.encode_hex(trx_id), status: "complete"}
            end)

          {wallets, transfers}
      end

    {:ok,
     st
     |> Map.put(:wallets, wallets)
     |> Map.put(:transfers, transfers)}
  end
end
