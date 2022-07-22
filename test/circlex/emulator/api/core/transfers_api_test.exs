defmodule Circlex.Emulator.Api.Core.TransfersApiTest do
  use Circlex.ApiCase
  alias Circlex.Emulator.Api.Core.TransfersApi
  doctest TransfersApi

  test "create_transfer/1" do
    assert {:ok,
            %{
              amount: %{amount: "12345.00", currency: "USD"},
              createDate: "2022-07-17T08:59:41.344582Z",
              destination: %{
                address: "0x871a9ff377ecf2632a0928950dceb181557f2e17",
                chain: "ETH",
                type: "blockchain"
              },
              id: "a033a6d8-05ae-11ed-9e62-6a1733211c00",
              source: %{id: "1000216185", type: "wallet"},
              status: "pending",
              transactionHash: nil
            }} ==
             TransfersApi.create_transfer(%{
               idempotencyKey: UUID.uuid1(),
               destination: %{
                 address: "0x871a9ff377ecf2632a0928950dceb181557f2e17",
                 chain: "ETH",
                 type: "blockchain"
               },
               amount: %{amount: "12345.00", currency: "USD"}
             })
  end

  test "list_transfers/1" do
    assert {:ok,
            [
              %{
                amount: %{amount: "8999998.14", currency: "USD"},
                createDate: "2022-05-05T16:49:04.541Z",
                destination: %{
                  address: "0x2eb953f992d4fa6e769fabf25d8218f21b793558",
                  chain: "ETH",
                  type: "blockchain"
                },
                id: "83f18616-0f26-499a-aa8f-4fa4d563b974",
                source: %{id: "1000216185", type: "wallet"},
                status: "complete",
                transactionHash:
                  "0xef6cf276368eb0e36162074b1c17a3256df14635c8603f076e826650c9f8a9ff"
              }
            ]} == TransfersApi.list_transfers(%{})
  end

  test "get_transfer/1" do
    assert {:ok,
            %{
              amount: %{amount: "8999998.14", currency: "USD"},
              createDate: "2022-05-05T16:49:04.541Z",
              destination: %{
                address: "0x2eb953f992d4fa6e769fabf25d8218f21b793558",
                chain: "ETH",
                type: "blockchain"
              },
              id: "83f18616-0f26-499a-aa8f-4fa4d563b974",
              source: %{id: "1000216185", type: "wallet"},
              status: "complete",
              transactionHash:
                "0xef6cf276368eb0e36162074b1c17a3256df14635c8603f076e826650c9f8a9ff"
            }} ==
             TransfersApi.get_transfer(%{transfer_id: "83f18616-0f26-499a-aa8f-4fa4d563b974"})
  end
end
