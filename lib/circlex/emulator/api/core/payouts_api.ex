defmodule Circlex.Emulator.Api.Core.PayoutsApi do
  @moduledoc """
  Mounted under `/v1/businessAccount/payouts`.
  """
  use Circlex.Emulator.Api

  alias Circlex.Emulator.State.PayoutState
  alias Circlex.Struct.Payout

  # https://developers.circle.com/reference/getbusinessaccountpayouts
  @route "/"
  def list_payouts(%{}) do
    with {:ok, master_wallet} <- get_master_wallet() do
      {:ok,
       Enum.map(
         PayoutState.all_payouts(source_wallet_id: master_wallet.wallet_id),
         fn payout -> Payout.serialize(payout, true) end
       )}
    end
  end

  # https://developers.circle.com/reference/getbusinessaccountpayout
  @route "/:payout_id"
  def get_payout(%{payout_id: payout_id}) do
    with {:ok, master_wallet} <- get_master_wallet(),
         {:ok, payout} <-
           PayoutState.get_payout(payout_id, source_wallet_id: master_wallet.wallet_id) do
      {:ok, Payout.serialize(payout, true)}
    end
  end

  # https://developers.circle.com/reference/createbusinessaccountpayout
  @route path: "/", method: :post
  def create_payout(%{
        idempotencyKey: idempotency_key,
        destination: destination,
        amount: %{amount: amount, currency: currency}
      }) do
    with :ok <- check_idempotency_key(idempotency_key),
         {:ok, source} <- get_master_source(),
         {:ok, payout} <-
           PayoutState.new_payout(source, destination, amount, currency, nil) do
      PayoutState.add_payout(payout)

      {:ok, Payout.serialize(payout, true)}
    end
  end
end
