defmodule Circlex.Emulator.Logic.LogicUtil do
  @moduledoc """
  Helper functions for common logic utilities.
  """

  alias Circlex.Struct.{Payout, Transfer}

  def update(els, find_fn, update_fn, allow_nop \\ false) do
    case Enum.find_index(els, find_fn) do
      nil ->
        if allow_nop do
          {:ok, els}
        else
          :not_found
        end

      index ->
        el = Enum.at(els, index)

        case update_fn.(el) do
          nil ->
            {:ok, List.delete_at(els, index)}

          new_val ->
            {:ok, List.replace_at(els, index, new_val)}
        end
    end
  end

  def update_or_add(els, find_fn, update_fn) do
    case Enum.find_index(els, find_fn) do
      nil ->
        [update_fn.(nil) | els]

      index ->
        el = Enum.at(els, index)
        List.replace_at(els, index, update_fn.(el))
    end
  end

  # TODO: Remove from State?
  def find(arr, finder) do
    case Enum.find(arr, finder) do
      nil ->
        :not_found

      val ->
        {:ok, val}
    end
  end

  def find!(arr, finder) do
    {:ok, val} = find(arr, finder)
    val
  end

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

  def add_currencies(x, y) do
    Decimal.new(x)
    |> Decimal.add(Decimal.new(y))
    |> Decimal.to_string()
  end
end
