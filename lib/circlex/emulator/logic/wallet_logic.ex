defmodule Circlex.Emulator.Logic.WalletLogic do
  alias Circlex.Emulator.Logic
  import Logic.LogicUtil
  alias Circlex.Struct.{Address, Amount, Wallet}

  def get_wallet(wallets, wallet_id) do
    find(wallets, fn %Wallet{wallet_id: id} -> id == wallet_id end)
  end

  def get_wallet_by_address(wallets, chain, currency, address) do
    find(wallets, fn %Wallet{addresses: addresses} ->
      Enum.any?(addresses, fn address_struct = %Address{} ->
        Address.match?(address_struct, chain, currency, address)
      end)
    end)
  end

  def master_wallet(wallets) do
    find(wallets, fn %Wallet{type: type} -> type == "merchant" end)
  end

  def add_wallet(wallets, wallet) do
    {:ok, [wallet | wallets]}
  end

  def update_balance(wallets, wallet_id, amount) do
    update(wallets, fn wallet -> wallet.wallet_id == wallet_id end, fn wallet ->
      do_update_balance(wallet, amount)
    end)
  end

  defp do_update_balance(wallet, amount) do
    new_balances =
      update_or_add(
        wallet.balances,
        fn balance -> balance.currency == amount.currency end,
        fn
          nil ->
            %Amount{currency: amount.currency, amount: amount.amount}

          balance ->
            %Amount{balance | amount: add_currencies(balance.amount, amount.amount)}
        end
      )

    %{wallet | balances: new_balances}
  end

  def update_wallet(wallets, wallet_id, wallet = %Wallet{}) do
    update_wallet(wallets, wallet_id, fn _ -> wallet end)
  end

  def update_wallet(wallets, wallet_id, f) when is_function(f) do
    update(
      wallets,
      fn wallet -> wallet.wallet_id == wallet_id end,
      f,
      "wallet not found: #{wallet_id}"
    )
  end
end
