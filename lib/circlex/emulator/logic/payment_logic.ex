defmodule Circlex.Emulator.Logic.PaymentLogic do
  import Circlex.Emulator.Logic.LogicUtil

  alias Circlex.Struct.{Payment, Wallet}
  alias Circlex.Emulator.Logic.WalletLogic

  def get_payment(payments, payment_id) do
    find(payments, fn %Payment{id: id} -> id == payment_id end)
  end

  def add_payment(payments, payment) do
    {:ok, [payment | payments]}
  end

  def update_payment(payments, payment_id, f) do
    update(payments, fn %Payment{id: id} -> id == payment_id end, f)
  end

  def process_payment(st = %{payments: payments, wallets: wallets}, payment_id) do
    {:ok, payment} = get_payment(payments, payment_id)

    case payment.source.type do
      "wire" ->
        {:ok, master_wallet} = WalletLogic.master_wallet(wallets)

        {:ok, wallets} =
          WalletLogic.update_balance(wallets, master_wallet.wallet_id, payment.amount)

        {:ok, payments} = update_payment(payments, payment.id, fn p -> %{p | status: "paid"} end)

        {:ok,
         st
         |> Map.put(:wallets, wallets)
         |> Map.put(:payments, payments)}

      _ ->
        #  TODO: Handle other kinds of payments
        {:ok, st}
    end
  end
end
