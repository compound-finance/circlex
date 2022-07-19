defmodule Circlex.Emulator.Logic.TransferLogic do
  import Circlex.Emulator.Logic.LogicUtil

  alias Circlex.Struct.Transfer

  def get_transfer(transfers, transfer_id) do
    find(transfers, fn %Transfer{id: id} -> id == transfer_id end)
  end

  def add_transfer(transfers, transfer) do
    {:ok, [transfer | transfers]}
  end

  def update_transfer(transfers, transfer_id, f) do
    update(transfers, fn %Transfer{id: id} -> id == transfer_id end, f)
  end
end
