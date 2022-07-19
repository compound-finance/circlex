defmodule Circlex.Emulator.Logic.PayoutLogic do
  import Circlex.Emulator.Logic.LogicUtil

  alias Circlex.Struct.Payout

  def get_payout(payouts, payout_id) do
    find(payouts, fn %Payout{id: id} -> id == payout_id end)
  end

  def add_payout(payouts, payout) do
    {:ok, [payout | payouts]}
  end

  def update_payout(payouts, payout_id, f) do
    update(payouts, fn %Payout{id: id} -> id == payout_id end, f)
  end
end
