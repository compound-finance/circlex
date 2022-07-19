defmodule Circlex.Emulator.Actor.WirePaymentActor do
  @moduledoc """
  Models a wire payment (transfer in)

  When we create a wire, we will credit the account's master wallet.

  Note: we do not need to initiate any on-chain transfers at this point.
  """
  use GenServer

  alias Circlex.Emulator.State
  alias Circlex.Emulator.State.{PaymentState, WalletState}
  alias Circlex.Emulator.Logic.{PaymentLogic, WalletLogic}
  alias Circlex.Struct.Payment

  def start_link(payment_id) do
    GenServer.start_link(__MODULE__, {payment_id})
  end

  @impl true
  def init({payment_id}) do
    Process.send_after(self(), :accept_wire, 1000)
    {:ok, %{payment_id: payment_id}}
  end

  @impl true
  def handle_info(:accept_wire, state = %{payment_id: payment_id}) do
    {:ok, payment} = PaymentState.get_payment(payment_id)

    case payment.status do
      "pending" ->
        State.update_st(fn st -> st |> PaymentLogic.process_payment(payment.id) end)
    end

    {:noreply, state}
  end
end
