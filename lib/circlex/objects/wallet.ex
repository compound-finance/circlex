defmodule Circlex.Objects.Wallet do
  defstruct [:wallet_id, :entity_id, :type, :description, :balances]

  alias Circlex.Emulator.State
  import Circlex.Objects.Util

  # Note: emulator-world only?
  def new(type, description, balances \\ []) do
    {:ok,
     %__MODULE__{
       wallet_id: State.next(:wallet_id),
       entity_id: State.next(:uuid),
       description: description,
       type: type,
       balances: balances
     }}
  end

  def deserialize(wallet) do
    %__MODULE__{
      wallet_id: fetch(wallet, :walletId),
      entity_id: fetch(wallet, :entityId),
      description: fetch(wallet, :description),
      type: fetch(wallet, :type),
      balances: fetch(wallet, :balances)
    }
  end

  def serialize(wallet) do
    %{
      walletId: wallet.wallet_id,
      entityId: wallet.entity_id,
      description: wallet.description,
      type: wallet.type,
      balances: []
    }
  end
end
