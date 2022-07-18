defmodule Circlex.Emulator.State.WalletState do
  alias Circlex.Emulator.State
  alias Circlex.Struct.Wallet

  import State.Util

  def all() do
    State.get_in(:wallets)
  end

  def get(id) do
    all()
    |> find!(fn %Wallet{wallet_id: wallet_id} -> to_string(id) == to_string(wallet_id) end)
  end

  def master_wallet() do
    all()
    |> find!(fn %Wallet{type: type} -> type == "merchant" end)
  end

  def add_wallet(wallet) do
    State.update_in(:wallets, fn wallets -> [wallet | wallets] end)
  end

  def update_wallet(wallet_id, f) do
    State.update_in(:wallets, fn wallets ->
      Enum.map(wallets, fn wallet ->
        if wallet.wallet_id == wallet_id, do: f.(wallet), else: wallet
      end)
    end)
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
end
