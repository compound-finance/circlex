defmodule Circlex.Struct.Wallet do
  defstruct [:wallet_id, :entity_id, :type, :description, :balances, :addresses]

  alias Circlex.Emulator.State
  import Circlex.Struct.Util

  def deserialize(wallet) do
    %__MODULE__{
      wallet_id: fetch(wallet, :walletId),
      entity_id: fetch(wallet, :entityId),
      description: fetch(wallet, :description),
      type: fetch(wallet, :type),
      balances: fetch(wallet, :balances),
      addresses: fetch(wallet, :addresses)
    }
  end

  def serialize(wallet, include_addresses \\ true) do
    Map.merge(
      %{
        walletId: wallet.wallet_id,
        entityId: wallet.entity_id,
        description: wallet.description,
        type: wallet.type,
        balances: wallet.balances
      },
      if(include_addresses, do: %{addresses: wallet.addresses}, else: %{})
    )
  end
end
