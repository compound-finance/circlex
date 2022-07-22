defmodule Circlex.Emulator.Actor.PayoutActorTest do
  use ExUnit.Case

  alias Circlex.Emulator.Actor.PayoutActor
  alias Circlex.Emulator.State
  alias Circlex.Emulator.State.{PayoutState, WalletState}
  alias Circlex.Struct.{Amount, Payout, SourceDest, Wallet}

  @payout %Payout{
    adjustments: nil,
    amount: %Amount{amount: "30.00", currency: "USD"},
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
    status: "pending",
    tracking_ref: nil,
    update_date: "2022-07-15T20:20:32.255Z"
  }

  setup do
    {:ok, state_pid} = State.start_link(Circlex.Test.get_opts())
    Process.put(:state_pid, state_pid)

    :ok
  end

  test "wire in processing flow" do
    PayoutState.add_payout(@payout)
    assert PayoutState.get_payout(@payout.id) == {:ok, @payout}
    {:ok, wallet} = WalletState.get_wallet(@payout.source_wallet_id)
    assert Wallet.get_balance(wallet, "USD") == "150234.93"

    {:ok, _actor} = PayoutActor.start_link(@payout.id)

    # Allow processing time
    :timer.sleep(2 * Circlex.Emulator.action_delay())

    assert PayoutState.get_payout(@payout.id) == {:ok, %{@payout | status: "complete", external_ref: "REFREF000"}}
    {:ok, wallet} = WalletState.get_wallet(@payout.source_wallet_id)
    assert Wallet.get_balance(wallet, "USD") == "150204.93"
  end
end
