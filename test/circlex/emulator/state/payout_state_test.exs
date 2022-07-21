defmodule Circlex.Emulator.State.PayoutStateTest do
  use ExUnit.Case
  alias Circlex.Emulator.State.PayoutState
  alias Circlex.Emulator.State
  alias Circlex.Struct.{Amount, Payout, SourceDest}
  doctest PayoutState

  @payout %Payout{
    adjustments: nil,
    amount: %Amount{amount: "12111.00", currency: "USD"},
    create_date: "2022-07-15T20:03:32.718Z",
    destination: %SourceDest{
      id: "4847be95-8b73-44cc-a329-549a25a776e2",
      type: :wire
    },
    fees: %Amount{amount: "25.00", currency: "USD"},
    id: "6e2e20bd-6ad6-4603-950b-64803647a4e6",
    return: nil,
    risk_evaluation: nil,
    source_wallet_id: "1000216185",
    status: "complete",
    tracking_ref: nil,
    update_date: "2022-07-15T20:20:32.255Z"
  }

  setup do
    {:ok, state_pid} = State.start_link(Circlex.Test.get_opts())
    Process.put(:state_pid, state_pid)

    :ok
  end

  test "all_payouts/0" do
    assert Enum.member?(PayoutState.all_payouts(), @payout)
  end

  describe "get_payout/1" do
    test "found" do
      assert {:ok, @payout} ==
               PayoutState.get_payout(@payout.id)
    end

    test "not found" do
      assert :not_found == PayoutState.get_payout("55")
    end
  end

  test "add_payout/1" do
    PayoutState.all_payouts()
    new_payout = %{@payout | id: @payout.id}
    PayoutState.add_payout(new_payout)
    assert [^new_payout | _] = PayoutState.all_payouts()
  end

  test "update_payout/1" do
    PayoutState.update_payout(@payout.id, fn payout ->
      %{payout | status: "complete"}
    end)

    assert {:ok, %{@payout | status: "complete"}} ==
             PayoutState.get_payout(@payout.id)
  end
end
