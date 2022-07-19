defmodule Circlex.Emulator.Api.Payments.PaymentsApi do
  @moduledoc """
  Mounted under `/v1/payments`.
  """
  use Circlex.Emulator.Api
  alias Circlex.Emulator.State.PaymentState
  alias Circlex.Struct.Payment

  # https://developers.circle.com/reference/payments-payments-get
  @route "/"
  def list_payments(%{}) do
    {:ok, Enum.map(PaymentState.all_payments(), &Payment.serialize/1)}
  end

  # https://developers.circle.com/reference/payments-payments-get-id
  @route "/:payment_id"
  def get_payment(%{payment_id: payment_id}) do
    with {:ok, payment} <- PaymentState.get_payment(payment_id) do
      {:ok, Payment.serialize(payment)}
    end
  end
end
