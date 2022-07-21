defmodule Circlex.Emulator.Actor.TransferActor do
  @moduledoc """
  Handles a transfer, either in or out, specifically handling:

  ```md
  1. Blockchain -> Wallet
  2. Wallet -> Wallet
  3. Wallet -> Blockchain
  ```
  """
  use GenServer

  alias Circlex.Emulator
  alias Circlex.Emulator.Notifier
  alias Circlex.Emulator.State
  alias Circlex.Emulator.State.{SubscriptionState, TransferState}
  alias Circlex.Emulator.Logic.TransferLogic
  alias Circlex.Struct.Transfer

  def start_link(transfer_id) do
    IO.puts("a0")
    GenServer.start_link(
      __MODULE__,
      {transfer_id, Process.get(:state_pid), Process.get(:signer_proc)}
    )
  end

  @impl true
  def init({transfer_id, state_pid, signer_proc}) do
    Process.put(:state_pid, state_pid)
    if not is_nil(signer_proc), do: Process.put(:signer_proc, signer_proc)
    Notifier.notify_transfer(transfer_id)
    Process.send_after(self(), :accept_transfer, Emulator.action_delay())
    {:ok, %{transfer_id: transfer_id}}
  end

  @impl true
  def handle_info(:accept_transfer, state = %{transfer_id: transfer_id}) do
    # TODO: Maybe check transfer tx id?
    {:ok, transfer} = TransferState.get_transfer(transfer_id)

    case transfer.status do
      "pending" ->
        # We've accepted the transfer in, set state and send notification
        State.update_st(fn st -> st |> TransferLogic.process_transfer(transfer.id) end)
        Notifier.notify_transfer(transfer.id)
    end

    {:noreply, state}
  end
end
