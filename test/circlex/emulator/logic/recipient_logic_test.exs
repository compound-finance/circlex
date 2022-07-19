defmodule Circlex.Emulator.Logic.RecipientLogicTest do
  use ExUnit.Case
  alias Circlex.Emulator.Logic.RecipientLogic
  alias Circlex.Struct.Recipient
  doctest RecipientLogic

  @recipient %Circlex.Struct.Recipient{
    address: "0x9dfb4f706a4747355a7ef65cd341a0289034a385",
    chain: "ETH",
    currency: "USD",
    description: "Treasury Adaptor v1",
    id: "7bfd6d2a-3682-52b5-a041-714af6913086"
  }

  setup do
    recipients = [@recipient]

    {:ok, %{recipients: recipients}}
  end

  test "get_recipient/2", %{recipients: recipients} do
    assert {:ok, @recipient} ==
             RecipientLogic.get_recipient(
               recipients,
               @recipient.id
             )
  end

  test "add_recipient/2", %{recipients: recipients} do
    new_recipient = %{@recipient | id: "new"}

    assert {:ok, [new_recipient, @recipient]} ==
             RecipientLogic.add_recipient(
               recipients,
               new_recipient
             )
  end

  describe "update_recipient/3" do
    test "setting recipient", %{recipients: recipients} do
      updated_recipient = %{@recipient | description: "cool"}

      assert {:ok, [updated_recipient]} ==
               RecipientLogic.update_recipient(recipients, @recipient.id, fn _ ->
                 updated_recipient
               end)
    end
  end
end
