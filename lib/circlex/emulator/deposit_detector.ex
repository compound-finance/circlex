defmodule Circlex.Emulator.DepositDetector do
  @moduledoc """
  Checks for Deposits
  """
  use GenServer

  alias Circlex.Emulator.State.{TransferState, WalletState}
  alias Circlex.Emulator.Actor.TransferActor
  alias Circlex.Struct.Amount

  require Logger

  @chain "ETH"
  @currency "USD"
  @usdc_decimals 6

  def start_link([filters, state_pid]) do
    GenServer.start_link(__MODULE__, {filters, state_pid})
  end

  @impl true
  def init({filters, state_pid}) do
    Process.put(:state_pid, state_pid)

    for filter <- filters do
      Signet.Filter.listen(filter)
    end

    {:ok, %{logs: [], events: %{}}}
  end

  def logs(pid) do
    GenServer.call(pid, :logs)
  end

  def events(pid) do
    GenServer.call(pid, :events)
  end

  @impl true
  def handle_info({:event, event, log}, state=%{events: events}) do
    trx_id = Signet.Util.encode_hex(log.transaction_hash)

    case event do
      {"Transfer", %{"from" => from, "to" => to, "amount" => amount}} ->
        # Okay, now let's see if it matches any known wallet.
        case WalletState.get_wallet_by_address(@chain, @currency, Signet.Util.encode_hex(to)) do
          {:ok, wallet} ->
            {:ok, transfer} =
              TransferState.new_transfer(
                %{
                  type: "blockchain",
                  chain: "ETH",
                  address: Signet.Util.encode_hex(from)
                },
                %{
                  type: "wallet",
                  id: wallet.wallet_id,
                  address: Signet.Util.encode_hex(to)
                },
                Amount.from_wei(amount, @usdc_decimals),
                trx_id
              )

            TransferState.add_transfer(transfer)

            TransferActor.start_link(transfer.id)
            Logger.info("Detected new USDC transfer to wallet via trx: #{trx_id}: #{inspect(transfer)}")

          :not_found ->
            Logger.info("Ignoring irrevelevant USDC transfer via trx: #{trx_id}...")
        end

      _ ->
        nil
    end

    {:noreply, %{state | events: Map.put(events, trx_id, event)}}
  end

  def handle_info({:log, log}, state=%{logs: logs}) do
    {:noreply, %{state|logs: [log.transaction_hash|logs]}}
  end

  def handle_call(:logs, _from, state=%{logs: logs}) do
    {:reply, logs, state}
  end

  def handle_call(:events, _from, state=%{events: events}) do
    {:reply, events, state}
  end
end
