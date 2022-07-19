defmodule Circlex.Emulator.State.RecipientStateTest do
  use ExUnit.Case
  alias Circlex.Emulator.State.RecipientState
  alias Circlex.Emulator.State
  alias Circlex.Struct.Recipient
  doctest RecipientState

  @recipient %Circlex.Struct.Recipient{
    address: "0x9dfb4f706a4747355a7ef65cd341a0289034a385",
    chain: "ETH",
    currency: "USD",
    description: "Treasury Adaptor v1",
    id: "7bfd6d2a-3682-52b5-a041-714af6913086"
  }

  setup do
    {:ok, state_pid} = State.start_link(Circlex.Test.get_opts())
    Process.put(:state_pid, state_pid)

    :ok
  end

  test "all_recipients/0" do
    assert Enum.member?(RecipientState.all_recipients(), @recipient)
  end

  describe "get_recipient/1" do
    test "found" do
      assert {:ok, @recipient} ==
               RecipientState.get_recipient(@recipient.id)
    end

    test "not found" do
      assert :not_found == RecipientState.get_recipient("55")
    end
  end

  test "add_recipient/1" do
    RecipientState.all_recipients()
    new_recipient = %{@recipient | id: @recipient.id}
    RecipientState.add_recipient(new_recipient)
    assert [^new_recipient | _] = RecipientState.all_recipients()
  end

  test "update_recipient/1" do
    RecipientState.update_recipient(@recipient.id, fn recipient ->
      %{recipient | description: "cool"}
    end)

    assert {:ok, %{@recipient | description: "cool"}} ==
             RecipientState.get_recipient(@recipient.id)
  end
end
