defmodule Circlex.Emulator.Api.Core.TransfersApi do
  @moduledoc """
  Mounted under `/v1/businessAccount/transfers`.
  """
  use Circlex.Emulator.Api

  alias Circlex.Emulator.State.TransferState
  alias Circlex.Emulator.Actor.TransferActor
  alias Circlex.Struct.Transfer

  # https://developers.circle.com/reference/searchbusinessaccounttransfers
  @route "/"
  def list_transfers(%{}) do
    with {:ok, master_wallet} <- get_master_wallet() do
      {:ok,
       Enum.map(
         TransferState.all_transfers(transfer_source: {:wallet, master_wallet.wallet_id}),
         &Transfer.serialize/1
       )}
    end
  end

  # https://developers.circle.com/reference/getbusinessaccounttransfer
  @route "/:transfer_id"
  def get_transfer(%{transfer_id: transfer_id}) do
    with {:ok, master_wallet} <- get_master_wallet(),
         {:ok, transfer} <-
           TransferState.get_transfer(transfer_id,
             transfer_source: {:wallet, master_wallet.wallet_id}
           ) do
      {:ok, Transfer.serialize(transfer)}
    end
  end

  # https://developers.circle.com/reference/createbusinessaccounttransfer
  @route path: "/", method: :post
  def create_transfer(%{
        idempotencyKey: idempotency_key,
        destination: destination,
        amount: amount
      }) do
    # TODO: Check idempotency key
    with :ok <- check_idempotency_key(idempotency_key),
         {:ok, source} <- get_master_source(),
         {:ok, transfer} <-
           TransferState.new_transfer(source, destination, amount) do
      TransferState.add_transfer(transfer)
      TransferActor.start_link(transfer.id)
      {:ok, Transfer.serialize(transfer)}
    end
  end
end
