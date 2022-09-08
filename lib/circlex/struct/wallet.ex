defmodule Circlex.Struct.Wallet do
  use Circlex.Struct.JasonHelper
  import Circlex.Struct.Util

  defstruct [:wallet_id, :entity_id, :type, :description, :balances, :addresses]

  def deserialize(wallet) do
    %__MODULE__{
      wallet_id: fetch(wallet, :walletId),
      entity_id: fetch(wallet, :entityId),
      description: fetch(wallet, :description),
      type: fetch(wallet, :type),
      balances: fetch(wallet, :balances) |> Enum.map(&Circlex.Struct.Amount.deserialize/1),
      addresses:
        (fetch(wallet, :addresses) || []) |> Enum.map(&Circlex.Struct.Address.deserialize/1)
    }
  end

  def serialize(wallet, include_addresses \\ true) do
    Map.merge(
      %{
        walletId: wallet.wallet_id,
        entityId: wallet.entity_id,
        description: wallet.description,
        type: wallet.type,
        balances: Enum.map(wallet.balances, &Circlex.Struct.Amount.serialize/1)
      },
      if(include_addresses,
        do: %{addresses: Enum.map(wallet.addresses, &Circlex.Struct.Address.serialize/1)},
        else: %{}
      )
    )
  end

  # TODO: Test
  def get_balance(wallet, currency) do
    balance =
      Enum.find_value(wallet.balances, fn balance ->
        if balance.currency == currency, do: balance, else: nil
      end)

    case balance do
      nil ->
        "0.00"

      _ ->
        balance.amount
    end
  end
end
