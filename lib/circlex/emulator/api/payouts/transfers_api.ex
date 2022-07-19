defmodule Circlex.Emulator.Api.Payouts.TransfersApi do
  @moduledoc """
  Mounted under `/v1/transfers`.
  """
  use Circlex.Emulator.Api
  alias Circlex.Emulator.State.TransferState
  alias Circlex.Struct.Transfer

  # https://developers.circle.com/reference/payouts-transfers-get
  @route "/"
  def list_transfers(%{}) do
    {:ok, Enum.map(TransferState.all_transfers(), &Transfer.serialize/1)}
  end

  # https://developers.circle.com/reference/payouts-transfers-get-id
  @route "/:transfer_id"
  def get_transfer(%{transfer_id: transfer_id}) do
    with {:ok, transfer} <- TransferState.get_transfer(transfer_id) do
      {:ok, Transfer.serialize(transfer)}
    end
  end

  # https://developers.circle.com/reference/payouts-transfers-create
  @route path: "/", method: :post
  def create_transfer(%{
        idempotencyKey: idempotency_key,
        source: source,
        destination: destination,
        amount: amount
      }) do
    # TODO: Check idempotency key

    with {:ok, transfer} <-
           TransferState.new_transfer(source, destination, amount) do
      TransferState.add_transfer(transfer)
      {:ok, Transfer.serialize(transfer)}
    end
  end
end
