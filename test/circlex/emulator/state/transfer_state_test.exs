defmodule Circlex.Emulator.State.TransferStateTest do
  use ExUnit.Case
  alias Circlex.Emulator.State.TransferState
  alias Circlex.Emulator.State
  alias Circlex.Struct.{Amount, SourceDest, Transfer}
  doctest TransferState

  @transfer %Transfer{
    amount: %Amount{amount: "8999998.14", currency: "USD"},
    create_date: "2022-05-05T16:49:04.541Z",
    destination: %SourceDest{
      address: "0x2eb953f992d4fa6e769fabf25d8218f21b793558",
      chain: "ETH",
      type: :blockchain
    },
    id: "83f18616-0f26-499a-aa8f-4fa4d563b974",
    source: %SourceDest{id: "1000216185", type: :wallet},
    status: "complete",
    transaction_hash: "0xef6cf276368eb0e36162074b1c17a3256df14635c8603f076e826650c9f8a9ff"
  }

  setup do
    {:ok, state_pid} = State.start_link(Circlex.Test.get_opts())
    Process.put(:state_pid, state_pid)

    :ok
  end

  test "all_transfers/0" do
    assert Enum.member?(TransferState.all_transfers(), @transfer)
  end

  describe "get_transfer/1" do
    test "found" do
      assert {:ok, @transfer} ==
               TransferState.get_transfer(@transfer.id)
    end

    test "not found" do
      assert :not_found == TransferState.get_transfer("55")
    end
  end

  test "add_transfer/1" do
    TransferState.all_transfers()
    new_transfer = %{@transfer | id: @transfer.id}
    TransferState.add_transfer(new_transfer)
    assert [^new_transfer | _] = TransferState.all_transfers()
  end

  test "update_transfer/1" do
    TransferState.update_transfer(@transfer.id, fn transfer ->
      %{transfer | status: "pending"}
    end)

    assert {:ok, %{@transfer | status: "pending"}} ==
             TransferState.get_transfer(@transfer.id)
  end
end
