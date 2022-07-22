defmodule Circlex.Struct.TransferTest do
  use ExUnit.Case
  alias Circlex.Struct.{Amount, SourceDest, Transfer}

  @transfer %Transfer{
    amount: %Amount{amount: "10000.00", currency: "USD"},
    create_date: "2022-05-05T16:49:04.541Z",
    source: %SourceDest{
      address: "0x2eb953f992d4fa6e769fabf25d8218f21b793558",
      chain: "ETH",
      type: :blockchain
    },
    id: "83f18616-0f26-499a-aa8f-4fa4d563b974",
    destination: %SourceDest{id: "1000216185", type: :wallet},
    status: "pending",
    transaction_hash: "0xef6cf276368eb0e36162074b1c17a3256df14635c8603f076e826650c9f8a9ff"
  }

  @transfer_ser %{
    amount: %{amount: "10000.00", currency: "USD"},
    createDate: "2022-05-05T16:49:04.541Z",
    source: %{
      address: "0x2eb953f992d4fa6e769fabf25d8218f21b793558",
      chain: "ETH",
      type: "blockchain"
    },
    id: "83f18616-0f26-499a-aa8f-4fa4d563b974",
    destination: %{id: "1000216185", type: "wallet"},
    status: "pending",
    transactionHash: "0xef6cf276368eb0e36162074b1c17a3256df14635c8603f076e826650c9f8a9ff"
  }

  describe "deserialize" do
    test "success" do
      assert Transfer.deserialize(@transfer_ser) == @transfer
    end
  end

  describe "serialize" do
    test "succeess" do
      assert Transfer.serialize(@transfer) == @transfer_ser
    end
  end
end
