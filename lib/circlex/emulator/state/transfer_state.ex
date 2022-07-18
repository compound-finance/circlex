defmodule Circlex.Emulator.State.TransferState do
  alias Circlex.Emulator.State
  alias Circlex.Struct.Transfer

  import State.Util

  def all(filters \\ []) do
    State.get_in(:transfers)
    |> apply_filters(filters)
  end

  def get(id, filters \\ []) do
    all(filters)
    |> find!(fn %Transfer{id: transfer_id} ->
      to_string(id) == to_string(transfer_id)
    end)
  end

  def add_transfer(transfer) do
    State.update_in(:transfers, fn transfers -> [transfer | transfers] end)
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
end
