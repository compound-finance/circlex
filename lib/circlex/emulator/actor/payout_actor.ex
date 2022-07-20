defmodule Circlex.Emulator.Actor.PayoutActor do
  @moduledoc """
  Models a wire payout (transfer out)

  When we create a wire, we will debit the account's master wallet.

  Note: we do not need to initiate any on-chain transfers.
  """
  use GenServer

  alias Circlex.Emulator
  alias Circlex.Emulator.Notifier
  alias Circlex.Emulator.State
  alias Circlex.Emulator.State.{PayoutState, SubscriptionState, WalletState}
  alias Circlex.Emulator.Logic.{PayoutLogic, WalletLogic}
  alias Circlex.Struct.Payout

  def start_link(payout_id) do
    GenServer.start_link(__MODULE__, {payout_id, Process.get(:state_pid)})
  end

  @impl true
  def init({payout_id, state_pid}) do
    Process.put(:state_pid, state_pid)
    Process.send_after(self(), :push_wire, Emulator.action_delay())
    Notifier.notify_payout(payout_id)
    {:ok, %{payout_id: payout_id}}
  end

  @impl true
  def handle_info(:push_wire, state = %{payout_id: payout_id}) do
    {:ok, payout} = PayoutState.get_payout(payout_id)

    case payout.status do
      "pending" ->
        # We've accepted the wire, set state and send notification
        State.update_st(fn st -> st |> PayoutLogic.process_payout(payout.id) end)
        Notifier.notify_payout(payout.id)
    end

    {:noreply, state}
  end
end
