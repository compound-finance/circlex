defmodule Circlex.Emulator.State.Util do
  alias Circlex.Struct.{Payout, Transfer}

  defp test_filter(payout = %Payout{}, {:source_wallet_id, source_wallet_id}) do
    payout.source_wallet_id == source_wallet_id
  end

  defp test_filter(transfer = %Transfer{}, {:transfer_source, {type, id}}) do
    transfer.source.type == type and transfer.source.id == id
  end

  def apply_filters(vals, filters) do
    Enum.filter(vals, fn val ->
      Enum.all?(filters, fn filter -> test_filter(val, filter) end)
    end)
  end

  def fetch(m, key) do
    case Map.get(m, key) do
      nil ->
        Map.get(m, to_string(key))

      els ->
        els
    end
  end

  def merchant_id(), do: Circlex.Emulator.merchant_id()
end
