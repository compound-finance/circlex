defmodule Circlex.Emulator.Api.Payouts.PayoutsApi do
  @moduledoc """
  Mounted under `/v1/payouts`.
  """
  use Circlex.Emulator.Api
  alias Circlex.Emulator.State.PayoutState
  alias Circlex.Struct.Payout

  # https://developers.circle.com/reference/payouts-payouts-get
  @route "/"
  def list_payouts(%{}) do
    {:ok, Enum.map(PayoutState.all_payouts(), &Payout.serialize/1)}
  end

  # https://developers.circle.com/reference/payouts-payouts-get-id
  @route "/:payout_id"
  def get_payout(%{payout_id: payout_id}) do
    with {:ok, payout} <- PayoutState.get_payout(payout_id) do
      {:ok, Payout.serialize(payout)}
    end
  end

  # https://developers.circle.com/reference/payouts-payouts-create
  @route path: "/", method: :post
  def create_payout(%{
        idempotencyKey: idempotency_key,
        source: source,
        destination: destination,
        amount: amount,
        metadata: metadata
      }) do
    # TODO: Check idempotency key

    with {:ok, payout} <-
           PayoutState.new_payout(source, destination, amount, metadata) do
      PayoutState.add_payout(payout)
      {:ok, Payout.serialize(payout)}
    end
  end
end
