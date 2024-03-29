defmodule Circlex.Emulator.Notifier do
  @moduledoc """
  Process to handle sending out notifications, such as SNS subscriptions.
  """

  use GenServer

  require Logger

  alias Circlex.Emulator.SNS
  alias Circlex.Emulator.SNS.Notification
  alias Circlex.Emulator.State.{PaymentState, PayoutState, SubscriptionState, TransferState}
  alias Circlex.Struct.{Payment, Payout, Transfer}

  def start_link(opts \\ []) do
    listeners = Keyword.get(opts, :listeners, [])

    GenServer.start_link(__MODULE__, %{state_pid: Process.get(:state_pid), listeners: listeners},
      name: __MODULE__
    )
  end

  @impl true
  def init(%{state_pid: state_pid, listeners: listeners}) do
    Process.put(:state_pid, state_pid)

    {:ok, %{listeners: listeners}}
  end

  def notify_payout(payout_id, name \\ __MODULE__) when is_binary(payout_id) do
    {:ok, payout} = PayoutState.get_payout(payout_id)

    notification =
      Notification.new(%{
        clientId: "c60d2d5b-203c-45bb-9f6e-93641d40a599",
        notificationType: "payouts",
        version: 1,
        payout: Payout.serialize(payout)
      })

    GenServer.cast(name, {:notify, notification})
  end

  def notify_payment(payment_id, name \\ __MODULE__) when is_binary(payment_id) do
    {:ok, payment} = PaymentState.get_payment(payment_id)

    notification =
      Notification.new(%{
        clientId: "c60d2d5b-203c-45bb-9f6e-93641d40a599",
        notificationType: "payments",
        version: 1,
        payment: Payment.serialize(payment)
      })

    GenServer.cast(name, {:notify, notification})
  end

  def notify_transfer(transfer_id, name \\ __MODULE__) when is_binary(transfer_id) do
    {:ok, transfer} = TransferState.get_transfer(transfer_id)

    notification =
      Notification.new(%{
        clientId: "c60d2d5b-203c-45bb-9f6e-93641d40a599",
        notificationType: "transfers",
        version: 1,
        transfer: Transfer.serialize(transfer)
      })

    GenServer.cast(name, {:notify, notification})
  end

  @impl true
  def handle_cast({:notify, notification}, state = %{listeners: listeners}) do
    # First, send notification to anything in notification state
    for subscription <- SubscriptionState.all_subscriptions() do
      Logger.info("Sending `#{notification.message.notificationType}` Notification")
      SNS.send_message(subscription.endpoint, notification)
    end

    # Also, send to any registered listeners
    for listener <- listeners do
      case listener do
        pid when is_pid(listener) or is_atom(pid) ->
          send(listener, {:notify, notification})

        f when is_function(f) ->
          f.(notification)

        {mod, fun, args} ->
          apply(mod, fun, [notification | args])
      end
    end

    {:noreply, state}
  end
end
