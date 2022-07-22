defmodule Circlex.Emulator.Actor.PaymentActorTest do
  use ExUnit.Case

  alias Circlex.Emulator.Actor.PaymentActor
  alias Circlex.Emulator.State
  alias Circlex.Emulator.State.{PaymentState, WalletState}
  alias Circlex.Struct.{Amount, Payment, SourceDest, Wallet}

  @payment %Payment{
    id: "24c26e1b-8666-46fa-96ea-892afcadb9bb",
    type: "payment",
    status: "pending",
    description: "Merchant Push Payment",
    amount: %Amount{
      amount: "50.00",
      currency: "USD"
    },
    fees: %Amount{
      amount: "2.00",
      currency: "USD"
    },
    create_date: "2022-07-15T21:10:03.635Z",
    update_date: "2022-07-15T21:11:03.863523Z",
    merchant_id: "5dfa1127-050b-4ba6-b9b5-b2015aa4c882",
    merchant_wallet_id: "1000216185",
    source: %SourceDest{
      id: "ad823515-3b51-4061-a016-d626e3cd105e",
      type: :wire
    },
    refunds: []
  }

  setup do
    {:ok, state_pid} = State.start_link(Circlex.Test.get_opts())
    Process.put(:state_pid, state_pid)

    :ok
  end

  test "wire in processing flow" do
    PaymentState.add_payment(@payment)
    assert PaymentState.get_payment(@payment.id) == {:ok, @payment}
    {:ok, master_wallet} = WalletState.master_wallet()
    assert Wallet.get_balance(master_wallet, "USD") == "150234.93"

    {:ok, _actor} = PaymentActor.start_link(@payment.id)

    # Allow processing time
    :timer.sleep(2 * Circlex.Emulator.action_delay())

    assert PaymentState.get_payment(@payment.id) == {:ok, %{@payment | status: "complete"}}
    {:ok, master_wallet} = WalletState.master_wallet()
    assert Wallet.get_balance(master_wallet, "USD") == "150284.93"
  end
end
