defmodule Circlex.Emulator.State.WalletState do
  alias Circlex.Emulator.State
  alias Circlex.Emulator.Logic.WalletLogic
  alias Circlex.Struct.Wallet

  import State.Util

  def all_wallets() do
    get_wallets_st(fn wallets -> wallets end)
  end

  def get_wallet(id) do
    get_wallets_st(fn wallets -> WalletLogic.get_wallet(wallets, id) end)
  end

  def master_wallet() do
    get_wallets_st(&WalletLogic.master_wallet/1)
  end

  def add_wallet(wallet) do
    update_wallets_st(fn wallets -> WalletLogic.add_wallet(wallets, wallet) end)
  end

  def update_wallet(wallet_id, f) do
    update_wallets_st(fn wallets -> WalletLogic.update_wallet(wallets, wallet_id, f) end)
  end

  def deserialize(st) do
    %{st | wallets: Enum.map(st.wallets, &Wallet.deserialize/1)}
  end

  def serialize(st) do
    %{st | wallets: Enum.map(st.wallets, &Wallet.serialize/1)}
  end

  def initial_state() do
    %{wallets: []}
  end

  def new_wallet(type, description) do
    {:ok,
     %Wallet{
       wallet_id: State.next(:wallet_id),
       entity_id: State.next(:uuid),
       description: description,
       type: type,
       balances: [],
       addresses: []
     }}
  end

  defp get_wallets_st(mfa_or_fn) do
    State.get_st(mfa_or_fn, [:wallets])
  end

  defp update_wallets_st(mfa_or_fn) do
    State.update_st(mfa_or_fn, [:wallets])
    :ok
  end
end
