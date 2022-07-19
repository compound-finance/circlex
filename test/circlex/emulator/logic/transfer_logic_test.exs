defmodule Circlex.Emulator.Logic.TransferLogicTest do
  use ExUnit.Case
  alias Circlex.Emulator.Logic.TransferLogic
  alias Circlex.Struct.{Amount, Transfer}
  doctest TransferLogic

  @transfer %Transfer{
    amount: %Amount{amount: "8999998.14", currency: "USD"},
    create_date: "2022-05-05T16:49:04.541Z",
    destination: %{
      address: "0x2eb953f992d4fa6e769fabf25d8218f21b793558",
      chain: "ETH",
      type: "blockchain"
    },
    id: "83f18616-0f26-499a-aa8f-4fa4d563b974",
    source: %{id: "1000216185", type: "wallet"},
    status: "complete",
    transaction_hash: "0xef6cf276368eb0e36162074b1c17a3256df14635c8603f076e826650c9f8a9ff"
  }

  setup do
    transfers = [@transfer]

    {:ok, %{transfers: transfers}}
  end

  test "get_transfer/2", %{transfers: transfers} do
    assert {:ok, @transfer} ==
             TransferLogic.get_transfer(
               transfers,
               @transfer.id
             )
  end

  test "add_transfer/2", %{transfers: transfers} do
    new_transfer = %{@transfer | id: "new"}

    assert {:ok, [new_transfer, @transfer]} ==
             TransferLogic.add_transfer(
               transfers,
               new_transfer
             )
  end

  describe "update_transfer/3" do
    test "setting transfer", %{transfers: transfers} do
      updated_transfer = %{@transfer | status: "cool"}

      assert {:ok, [updated_transfer]} ==
               TransferLogic.update_transfer(transfers, @transfer.id, fn _ -> updated_transfer end)
    end
  end
end
