defmodule Circlex.Emulator.Logic.RecipientLogic do
  import Circlex.Emulator.Logic.LogicUtil

  alias Circlex.Struct.Recipient

  def get_recipient(recipients, recipient_id) do
    find(recipients, fn %Recipient{id: id} -> id == recipient_id end)
  end

  def add_recipient(recipients, recipient) do
    {:ok, [recipient | recipients]}
  end

  def update_recipient(recipients, recipient_id, f) do
    update(recipients, fn %Recipient{id: id} -> id == recipient_id end, f)
  end
end
