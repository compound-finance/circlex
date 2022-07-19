defmodule Circlex.Emulator.Api.MocksApi do
  @moduledoc """
  Mounted under `/v1/mocks`.
  """
  use Circlex.Emulator.Api
  alias Circlex.Emulator.State.PaymentState
  alias Circlex.Struct.Payment

  # https://developers.circle.com/reference/payments-payments-mock-create
  @route path: "/payments/wire", method: :post
  def list_payments(%{}) do
    {:ok, Enum.map(PaymentState.all_payments(), &Payment.serialize/1)}
  end
end
