defmodule Circlex.Emulator.Actor.PaymentActor do
  @moduledoc """
  Models a wire payment (transfer in)

  When we create a wire, we will credit the account's master wallet.

  Note: we do not need to initiate any on-chain transfers at this point.
  """
  use GenServer

  alias Circlex.Emulator.State
  alias Circlex.Emulator.State.{PaymentState, SubscriptionState, WalletState}
  alias Circlex.Emulator.Logic.{PaymentLogic, WalletLogic}
  alias Circlex.Emulator.SNS.Notification
  alias Circlex.Struct.Payment

  defp action_delay(), do: Keyword.fetch!(Application.get_env(:circlex, :emulator), :action_delay_ms)

  def start_link(payment_id) do
    GenServer.start_link(__MODULE__, {payment_id, Process.get(:state_pid)})
  end

  @impl true
  def init({payment_id, state_pid}) do
    Process.put(:state_pid, state_pid)
    Process.send_after(self(), :accept_wire, action_delay())
    notify(payment_id)
    {:ok, %{payment_id: payment_id}}
  end

  @impl true
  def handle_info(:accept_wire, state = %{payment_id: payment_id}) do
    {:ok, payment} = PaymentState.get_payment(payment_id)

    case payment.status do
      "pending" ->
        # We've accepted the wire, set state and send notification
        State.update_st(fn st -> st |> PaymentLogic.process_payment(payment.id) end)
    end

    {:noreply, state}
  end

  defp notify(payment_id) when is_binary(payment_id) do
    {:ok, payment} = PaymentState.get_payment(payment_id)

    notification =
      Notification.new(%{
        clientId: "c60d2d5b-203c-45bb-9f6e-93641d40a599",
        notificationType: "payments",
        version: 1,
        payment: Payment.serialize(payment)
      })
      |> IO.inspect(label: "payment notification")

    SubscriptionState.send_notifications(notification)
  end
end
