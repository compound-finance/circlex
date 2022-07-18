defmodule Circlex.Emulator.State.PayoutState do
  alias Circlex.Emulator.State
  alias Circlex.Struct.Payout

  import State.Util

  def all(filters \\ []) do
    State.get_in(:payouts)
    |> apply_filters(filters)
  end

  def get(id, filters \\ []) do
    all(filters)
    |> find!(fn %Payout{id: payout_id} ->
      to_string(id) == to_string(payout_id)
    end)
  end

  def add_payout(payout) do
    State.update_in(:payouts, fn payouts -> [payout | payouts] end)
  end

  def deserialize(st) do
    %{st | payouts: Enum.map(st.payouts, &Payout.deserialize/1)}
  end

  def serialize(st) do
    %{st | payouts: Enum.map(st.payouts, &Payout.serialize/1)}
  end

  def initial_state() do
    %{payouts: []}
  end
end
