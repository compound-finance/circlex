defmodule Circlex.Emulator.State.PaymentState do
  alias Circlex.Emulator.State
  alias Circlex.Struct.{Amount, Payment, SourceDest}
  alias Circlex.Emulator.Logic.PaymentLogic

  import State.Util

  def all_payments(filters \\ []) do
    get_payments_st(fn payments -> payments end, filters)
  end

  def get_payment(id, filters \\ []) do
    get_payments_st(fn payments -> PaymentLogic.get_payment(payments, id) end, filters)
  end

  def add_payment(payment) do
    update_payments_st(fn payments -> PaymentLogic.add_payment(payments, payment) end)
  end

  def update_payment(payment_id, f) do
    update_payments_st(fn payments -> PaymentLogic.update_payment(payments, payment_id, f) end)
  end

  def new_payment(wallet_id, bank_account_id, amount, currency) do
    {:ok,
     %Payment{
       id: State.next(:uuid),
       type: "payment",
       status: "pending",
       description: "Merchant Push Payment",
       amount: %Amount{
         amount: amount,
         currency: currency
       },
       fees: %Amount{
         amount: "2.00",
         currency: "USD"
       },
       create_date: State.next(:date),
       update_date: State.next(:date),
       merchant_id: merchant_id(),
       merchant_wallet_id: wallet_id,
       source:
         SourceDest.deserialize(%{
           id: bank_account_id,
           type: "wire"
         }),
       refunds: []
     }}
  end

  def deserialize(st) do
    %{st | payments: Enum.map(st.payments, &Payment.deserialize/1)}
  end

  def serialize(st) do
    %{st | payments: Enum.map(st.payments, &Payment.serialize/1)}
  end

  def initial_state() do
    %{payments: []}
  end

  defp get_payments_st(mfa_or_fn, filters) do
    State.get_st(mfa_or_fn, [:payments], &apply_filters(&1, filters))
  end

  defp update_payments_st(mfa_or_fn, filters \\ []) do
    State.update_st(mfa_or_fn, [:payments], &apply_filters(&1, filters))
  end
end
