defmodule Circlex.Emulator.State.PaymentStateTest do
  use ExUnit.Case
  alias Circlex.Emulator.State.PaymentState
  alias Circlex.Emulator.State
  alias Circlex.Struct.{Amount, Payment}
  doctest PaymentState

  @payment %Payment{
    id: "24c26e1b-8666-46fa-96ea-892afcadb9bb",
    type: "payment",
    status: "paid",
    description: "Merchant Push Payment",
    amount: %Amount{
      amount: "3.14",
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
    source: %{
      id: "ad823515-3b51-4061-a016-d626e3cd105e",
      type: "wire"
    },
    refunds: []
  }

  setup do
    {:ok, state_pid} = State.start_link(Circlex.Test.get_opts())
    Process.put(:state_pid, state_pid)

    :ok
  end

  test "all_payments/0" do
    assert Enum.member?(PaymentState.all_payments(), @payment)
  end

  describe "get_payment/1" do
    test "found" do
      assert {:ok, @payment} ==
               PaymentState.get_payment(@payment.id)
    end

    test "not found" do
      assert :not_found == PaymentState.get_payment("55")
    end
  end

  test "add_payment/1" do
    PaymentState.all_payments()
    new_payment = %{@payment | id: @payment.id}
    PaymentState.add_payment(new_payment)
    assert [^new_payment | _] = PaymentState.all_payments()
  end

  test "update_payment/1" do
    PaymentState.update_payment(@payment.id, fn payment ->
      %{payment | status: "complete"}
    end)

    assert {:ok, %{@payment | status: "complete"}} ==
             PaymentState.get_payment(@payment.id)
  end
end
