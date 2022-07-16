defmodule Circlex.Emulator.State.Wallet do
  alias Circlex.Emulator.State

  defstruct [:wallet_id, :entity_id, :type, :balances]

  def all() do
    State.get_in(:wallets, [])
  end

  def get(id) do
    State.get_in(:wallets, [])
    |> find!(fn %__MODULE__{wallet_id: wallet_id} -> id == wallet_id end)
  end

  def master_wallet() do
    State.get_in(:wallets, [])
    |> IO.inspect(label: "wallets")
    |> find!(fn %__MODULE__{type: type} -> type == "merchant" end)
  end

  def create(wallet_id, entity_id, type, balances) do
    State.update_in(
      :wallets,
      fn wallets ->
        [%__MODULE__{wallet_id: wallet_id, entity_id: entity_id, type: type, balances: balances} | wallets]
      end,
      []
    )
  end

  defp find!(arr, finder) do
    case Enum.find(arr, finder) do
      nil ->
        :not_found

      val ->
        {:ok, val}
    end
  end

  def deserialize(state) do
    %{
      state
      | wallets:
          Enum.map(state.wallets, fn wallet ->
            %__MODULE__{
              wallet_id: wallet.walletId,
              entity_id: wallet.entityId,
              type: wallet.type,
              balances: []
            }
          end)
    }
  end

  def serialize(state) do
    %{
      state
      | wallets:
          Enum.map(state.wallets, fn wallet ->
            %{
              walletId: wallet.wallet_id,
              entityId: wallet.entity_id,
              type: wallet.type,
              balances: []
            }
          end)
    }
  end

  def initial_state() do
    %{wallets: []}
  end
end
