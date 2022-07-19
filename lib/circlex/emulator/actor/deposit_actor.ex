defmodule Circlex.Emulator.Actor.DepositActor do
  @moduledoc """
  Checks for Deposits
  """
  use GenServer

  alias Circlex.Emulator.State.WalletState

  require Logger

  @chain "ETH"
  @currency "USD"

  def start_link([filters, state_pid]) do
    GenServer.start_link(__MODULE__, {filters, state_pid})
  end

  @impl true
  def init({filters, state_pid}) do
    Process.put(:state_pid, state_pid)

    for filter <- filters do
      Signet.Filter.listen(filter)
    end

    {:ok, %{}}
  end

  @impl true
  def handle_info({:event, event}, state) do
    # Deposit detected!
    IO.inspect(event, label: "deposit detected")

    case event do
      {"Transfer", %{from: from, to: to, amount: amount}} ->
        # Okay, now let's see if it matches any known wallet.
        WalletState.get_wallet_by_address(@chain, @currency, Signet.Util.encode_hex(to))
        |> IO.inspect("deposited wallet")

      _ ->
        nil
    end

    {:noreply, state}
  end

  def handle_info({:log, log}, state) do
    {:noreply, state}
  end
end
