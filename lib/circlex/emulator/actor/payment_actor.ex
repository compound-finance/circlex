defmodule Circlex.Emulator.Actor.PaymentActor do
  @moduledoc """
  Models a wire payment (transfer in)

  When we create a wire, we will credit the account's master wallet.

  Note: we do not need to initiate any on-chain transfers
  """
  use GenServer

  alias Circlex.Emulator
  alias Circlex.Emulator.Notifier
  alias Circlex.Emulator.State
  alias Circlex.Emulator.State.PaymentState
  alias Circlex.Emulator.Logic.PaymentLogic

  def start_link(payment_id) do
    GenServer.start_link(__MODULE__, {payment_id, Process.get(:state_pid)})
  end

  @impl true
  def init({payment_id, state_pid}) do
    Process.put(:state_pid, state_pid)
    Process.send_after(self(), :accept_wire, Emulator.action_delay())
    Notifier.notify_payment(payment_id)
    {:ok, %{payment_id: payment_id}}
  end

  @impl true
  def handle_info(:accept_wire, state = %{payment_id: payment_id}) do
    {:ok, payment} = PaymentState.get_payment(payment_id)

    case payment.status do
      "pending" ->
        # We've accepted the wire, set state and send notification
        State.update_st(fn st -> st |> PaymentLogic.process_payment(payment.id) end)
        Notifier.notify_payment(payment.id)
    end

    {:noreply, state}
  end
end
