defmodule Circlex.Emulator.State.TransferState do
  alias Circlex.Emulator.State
  alias Circlex.Emulator.State.RecipientState
  alias Circlex.Struct.{Amount, Transfer}
  alias Circlex.Emulator.Logic.TransferLogic

  import State.Util

  def all_transfers(filters \\ []) do
    get_transfers_st(fn transfers -> transfers end, filters)
  end

  def get_transfer(id, filters \\ []) do
    get_transfers_st(fn transfers -> TransferLogic.get_transfer(transfers, id) end, filters)
  end

  def add_transfer(transfer) do
    update_transfers_st(fn transfers -> TransferLogic.add_transfer(transfers, transfer) end)
  end

  def update_transfer(transfer_id, f) do
    update_transfers_st(fn transfers ->
      TransferLogic.update_transfer(transfers, transfer_id, f)
    end)
  end

  def new_transfer(source, destination, amount, transaction_hash \\ nil) do
    destination =
      case destination.type do
        "verified_blockchain" ->
          {:ok, recipient} = RecipientState.get_recipient(destination.addressId)

          %{
            type: "blockchain",
            address: recipient.address,
            chain: recipient.chain
          }

        _ ->
          destination
      end

    {:ok,
     %Transfer{
       id: State.next(:uuid),
       source: source,
       destination: destination,
       amount: Amount.deserialize(amount),
       status: "pending",
       transaction_hash: transaction_hash,
       create_date: State.next(:date)
     }}
  end

  def deserialize(st) do
    %{st | transfers: Enum.map(st.transfers, &Transfer.deserialize/1)}
  end

  def serialize(st) do
    %{st | transfers: Enum.map(st.transfers, &Transfer.serialize/1)}
  end

  def initial_state() do
    %{transfers: []}
  end

  defp get_transfers_st(mfa_or_fn, filters \\ []) do
    State.get_st(mfa_or_fn, [:transfers], &apply_filters(&1, filters))
  end

  defp update_transfers_st(mfa_or_fn, filters \\ []) do
    State.update_st(mfa_or_fn, [:transfers], &apply_filters(&1, filters))
  end
end
