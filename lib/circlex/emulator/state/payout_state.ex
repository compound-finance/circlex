defmodule Circlex.Emulator.State.PayoutState do
    alias Circlex.Emulator.State
  alias Circlex.Struct.Payout
  alias Circlex.Emulator.Logic.PayoutLogic

  import State.Util

  def all_payouts(filters \\ []) do
    get_payouts_st(fn payouts -> payouts end, filters)
  end

  def get_payout(id, filters \\ []) do
    get_payouts_st(fn payouts -> PayoutLogic.get_payout(payouts, id) end, filters)
  end

  def add_payout(payout) do
    update_payouts_st(fn payouts -> PayoutLogic.add_payout(payouts, payout) end)
  end

  def update_payout(payout_id, f) do
    update_payouts_st(fn payouts -> PayoutLogic.update_payout(payouts, payout_id, f) end)
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

  defp get_payouts_st(mfa_or_fn, filters \\ []) do
    State.get_st(mfa_or_fn, [:payouts], &apply_filters(&1, filters))
  end

  defp update_payouts_st(mfa_or_fn, filters \\ []) do
    State.update_st(mfa_or_fn, [:payouts], &apply_filters(&1, filters))
  end
end
