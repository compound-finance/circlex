defmodule Circlex.Emulator.DepositDetectorTest do
  use ExUnit.Case
  alias Circlex.Emulator.DepositDetector
  alias Circlex.Emulator.State
  alias State.WalletState
  alias Circlex.Struct.Wallet
  doctest DepositDetector

  setup do
    {:ok, state_pid} = State.start_link(Circlex.Test.get_opts())
    {:ok, deposit_detector} = DepositDetector.start_link([[], state_pid])
    log = %Signet.Filter.Log{transaction_hash: <<0xCC::256>>}

    {:ok, %{deposit_detector: deposit_detector, log: log}}
  end

  test "handles tracking a log", %{deposit_detector: deposit_detector, log: log} do
    send(deposit_detector, {:log, log})
    assert DepositDetector.logs(deposit_detector) == [<<0xCC::256>>]
  end

  test "handles tracking an irrelevant event", %{deposit_detector: deposit_detector, log: log} do
    event = {"Transfer", %{"from" => <<1::160>>, "to" => <<2::160>>, "amount" => 500}}

    send(deposit_detector, {:event, event, log})

    assert DepositDetector.events(deposit_detector) == %{
             "0x00000000000000000000000000000000000000000000000000000000000000CC" =>
               {"Transfer",
                %{
                  "amount" => 500,
                  "from" => <<1::160>>,
                  "to" => <<2::160>>
                }}
           }
  end

  test "handles relevant transfer", %{deposit_detector: deposit_detector, log: log} do
    wallet_address = Signet.Util.decode_hex!("0x522c4caaf435fdf1822c7b6a081858344623cf84")
    {:ok, master_wallet} = WalletState.master_wallet()
    assert Wallet.get_balance(master_wallet, "USD") == "150234.93"

    event =
      {"Transfer",
       %{
         "from" => <<1::160>>,
         "to" => wallet_address,
         "amount" => 1_000_000
       }}

    send(deposit_detector, {:event, event, log})

    assert DepositDetector.events(deposit_detector) == %{
             "0x00000000000000000000000000000000000000000000000000000000000000CC" =>
               {"Transfer",
                %{
                  "amount" => 1_000_000,
                  "from" => <<1::160>>,
                  "to" => wallet_address
                }}
           }

    # Allow processing time
    :timer.sleep(2 * Circlex.Emulator.action_delay())

    {:ok, master_wallet} = WalletState.master_wallet()
    assert Wallet.get_balance(master_wallet, "USD") == "150235.93"
  end
end
