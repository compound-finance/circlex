defmodule Circlex.Emulator.Api.Payouts.PayoutsApi do
  @moduledoc """
  Mounted under `/v1/payouts`.
  """
  use Circlex.Emulator.Api

  alias Circlex.Emulator.State.PayoutState
  alias Circlex.Emulator.Actor.PayoutActor
  alias Circlex.Struct.Payout

  # https://developers.circle.com/reference/payouts-payouts-get
  @route "/"
  def list_payouts(%{}) do
    {:ok, Enum.map(PayoutState.all_payouts(), fn payout -> Payout.serialize(payout, true) end)}
  end

  # https://developers.circle.com/reference/payouts-payouts-get-id
  @route "/:payout_id"
  def get_payout(%{payout_id: payout_id}) do
    with {:ok, payout} <- PayoutState.get_payout(payout_id) do
      {:ok, Payout.serialize(payout, true)}
    end
  end

  # https://developers.circle.com/reference/payouts-payouts-create
  @route path: "/", method: :post
  def create_payout(%{
        idempotencyKey: idempotency_key,
        source: source,
        destination: destination,
        amount: %{amount: amount, currency: currency},
        metadata: metadata
      }) do
    # TODO: Check idempotency key
    with :ok <- check_idempotency_key(idempotency_key),
         {:ok, payout} <-
           PayoutState.new_payout(source, destination, amount, currency, metadata) do
      PayoutState.add_payout(payout)
      PayoutActor.start_link(payout.id)
      {:ok, Payout.serialize(payout, true)}
    end
  end
end
