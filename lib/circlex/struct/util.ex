defmodule Circlex.Struct.Util do
  def fetch(m, key) do
    case Map.get(m, key) do
      nil ->
        Map.get(m, to_string(key))

      els ->
        els
    end
  end
end
