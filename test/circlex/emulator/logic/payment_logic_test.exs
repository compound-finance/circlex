defmodule Circlex.Emulator.Logic.PaymentLogicTest do
  use ExUnit.Case
  alias Circlex.Emulator.Logic.PaymentLogic
  alias Circlex.Struct.{Amount, Payment, Wallet}
  doctest PaymentLogic

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
    source: %{
      id: "ad823515-3b51-4061-a016-d626e3cd105e",
      type: :wire
    },
    refunds: []
  }

  @wallet %Wallet{
    balances: [%Amount{amount: "100.00", currency: "USD"}],
    description: "Master Wallet",
    entity_id: "5dfa1127-050b-4ba6-b9b5-b2015aa4c882",
    type: "merchant",
    wallet_id: "1000216185"
  }

  setup do
    payments = [@payment]
    wallets = [@wallet]

    {:ok, %{payments: payments, wallets: wallets}}
  end

  test "get_payment/2", %{payments: payments} do
    assert {:ok, @payment} ==
             PaymentLogic.get_payment(payments, "24c26e1b-8666-46fa-96ea-892afcadb9bb")
  end

  test "process_payment", %{payments: payments, wallets: wallets} do
    assert {
             :ok,
             %{
               payments: [
                 %Payment{
                   amount: %Amount{amount: "50.00", currency: "USD"},
                   create_date: "2022-07-15T21:10:03.635Z",
                   description: "Merchant Push Payment",
                   fees: %Amount{amount: "2.00", currency: "USD"},
                   id: "24c26e1b-8666-46fa-96ea-892afcadb9bb",
                   merchant_id: "5dfa1127-050b-4ba6-b9b5-b2015aa4c882",
                   merchant_wallet_id: "1000216185",
                   refunds: [],
                   source: %{id: "ad823515-3b51-4061-a016-d626e3cd105e", type: :wire},
                   status: "paid",
                   type: "payment",
                   update_date: "2022-07-15T21:11:03.863523Z"
                 }
               ],
               wallets: [
                 %Wallet{
                   addresses: nil,
                   balances: [%Amount{amount: "150.00", currency: "USD"}],
                   description: "Master Wallet",
                   entity_id: "5dfa1127-050b-4ba6-b9b5-b2015aa4c882",
                   type: "merchant",
                   wallet_id: "1000216185"
                 }
               ]
             }
           } = PaymentLogic.process_payment(%{payments: payments, wallets: wallets}, @payment.id)
  end

  describe "update_payment/3" do
    test "setting payment", %{payments: payments} do
      updated_payment = %{@payment | description: "cool"}

      assert {:ok, [updated_payment]} ==
               PaymentLogic.update_payment(payments, @payment.id, fn _ -> updated_payment end)
    end
  end
end
