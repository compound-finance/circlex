defmodule Circlex.Emulator.State.Util do
  def find!(arr, finder) do
    case Enum.find(arr, finder) do
      nil ->
        :not_found

      val ->
        {:ok, val}
    end
  end
end
