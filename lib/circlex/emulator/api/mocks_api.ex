defmodule Circlex.Emulator.Api.MocksApi do
  @moduledoc """
  Mounted under `/v1/mocks`.
  """
  use Circlex.Emulator.Api
  alias Circlex.Emulator.Actor.WirePaymentActor
  alias Circlex.Emulator.State.{BankAccountState, PaymentState}
  alias Circlex.Struct.Payment

  # https://developers.circle.com/reference/payments-payments-mock-create
  @route path: "/payments/wire", method: :post
  def create_mock_wire(%{trackingRef: tracking_ref, amount: %{amount: amount, currency: currency}}) do
    with {:ok, master_wallet} <- get_master_wallet() do
      with {:ok, bank_account} <- BankAccountState.get_bank_account_by_tracking_ref(tracking_ref) do
        {:ok, payment} =
          PaymentState.new_payment(master_wallet.wallet_id, bank_account.id, amount, currency)
          
          IO.inspect(payment, label: "payment")

          PaymentState.add_payment(payment)

        WirePaymentActor.start_link(payment.id)

        {:ok, Payment.serialize(payment)}
      end
    end
  end
end
