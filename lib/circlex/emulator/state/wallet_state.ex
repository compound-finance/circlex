defmodule Circlex.Emulator.State.WalletState do
  alias Circlex.Emulator.State
  alias Circlex.Emulator.Logic.WalletLogic
  alias Circlex.Struct.{Address, Wallet}

  import State.Util

  def all_wallets() do
    get_wallets_st(fn wallets -> wallets end)
  end

  def get_wallet(id) do
    get_wallets_st(fn wallets -> WalletLogic.get_wallet(wallets, id) end)
  end

  def get_wallet_by_address(chain, currency, address) do
    get_wallets_st(fn wallets ->
      WalletLogic.get_wallet_by_address(wallets, chain, currency, address)
    end)
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
       entity_id: merchant_id(),
       description: description,
       type: type,
       balances: [],
       addresses: []
     }}
  end

  def new_address(chain, currency) do
    case {chain, currency} do
      {"ETH", "USD"} ->
        {eth_address, priv_key} = State.next(:eth_keypair)

        {:ok,
         %Address{
           address: String.downcase(Signet.Util.encode_hex(eth_address)),
           priv_key: String.downcase(Signet.Util.encode_hex(priv_key)),
           currency: currency,
           chain: chain
         }}

      _ ->
        {:error, "Unable to generate key pair for chain #{chain} currency: #{currency}"}
    end
  end

  def add_address_to_wallet(wallet_id, address) do
    update_wallet(wallet_id, fn wallet ->
      %{wallet | addresses: [address | wallet.addresses]}
    end)
  end

  defp get_wallets_st(mfa_or_fn) do
    State.get_st(mfa_or_fn, [:wallets])
  end

  defp update_wallets_st(mfa_or_fn) do
    State.update_st(mfa_or_fn, [:wallets])
    :ok
  end
end
