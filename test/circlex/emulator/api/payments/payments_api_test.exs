defmodule Circlex.Emulator.Api.Payments.PaymentsApiTest do
  use Circlex.ApiCase
  alias Circlex.Emulator.Api.Payments.PaymentsApi
  doctest PaymentsApi

  test "list_payments/1" do
    assert {:ok,
            [
              %{
                amount: %{amount: "3.14", currency: "USD"},
                createDate: "2022-07-15T21:10:03.635Z",
                fees: %{amount: "2.00", currency: "USD"},
                id: "24c26e1b-8666-46fa-96ea-892afcadb9bb",
                status: "paid",
                updateDate: "2022-07-15T21:11:03.863523Z",
                description: "Merchant Push Payment",
                merchantId: "5dfa1127-050b-4ba6-b9b5-b2015aa4c882",
                merchantWalletId: "1000216185",
                refunds: [],
                source: %{id: "ad823515-3b51-4061-a016-d626e3cd105e", type: "wire"},
                type: "payment"
              }
            ]} == PaymentsApi.list_payments(%{})
  end

  test "get_payment/1" do
    assert {:ok,
            %{
              amount: %{amount: "3.14", currency: "USD"},
              createDate: "2022-07-15T21:10:03.635Z",
              fees: %{amount: "2.00", currency: "USD"},
              id: "24c26e1b-8666-46fa-96ea-892afcadb9bb",
              status: "paid",
              updateDate: "2022-07-15T21:11:03.863523Z",
              description: "Merchant Push Payment",
              merchantId: "5dfa1127-050b-4ba6-b9b5-b2015aa4c882",
              merchantWalletId: "1000216185",
              refunds: [],
              source: %{id: "ad823515-3b51-4061-a016-d626e3cd105e", type: "wire"},
              type: "payment"
            }} ==
             PaymentsApi.get_payment(%{payment_id: "24c26e1b-8666-46fa-96ea-892afcadb9bb"})
  end
end
