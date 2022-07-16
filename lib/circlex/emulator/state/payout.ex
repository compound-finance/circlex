defmodule Circlex.Emulator.State.Payout do
  alias Circlex.Emulator.State

  defstruct [:id, :name]

  def all() do
    State.get_in(:payouts, [])
  end

  def get(id) do
    State.get_in(:payouts, [])
    |> find!(fn %__MODULE__{id: payout_id} -> id == payout_id end)
  end

  def create(id, name) do
    State.update_in(
      :payouts,
      fn payouts ->
        [%__MODULE__{id: id, name: name} | payouts]
      end,
      []
    )
  end

  defp find!(arr, finder) do
    case Enum.find(arr, finder) do
      nil ->
        :not_found

      val ->
        {:ok, val}
    end
  end
end
