defmodule Circlex.Emulator.Api.Accounts.WalletsApi do
  @moduledoc """
  Mounted under `/v1/wallets`.
  """
  use Circlex.Emulator.Api
  alias Circlex.Emulator.State.WalletState
  alias Circlex.Struct.{Address, Wallet}

  # https://developers.circle.com/reference/accounts-wallets-get
  @route "/"
  def list_wallets(%{}) do
    {:ok, Enum.map(WalletState.all_wallets(), &Wallet.serialize(&1, false))}
  end

  # https://developers.circle.com/reference/accounts-wallets-create
  @route path: "/", method: :post
  def create_wallet(%{idempotencyKey: idempotency_key, description: description}) do
    with :ok <- check_idempotency_key(idempotency_key),
         {:ok, wallet} <- WalletState.new_wallet(:end_user_wallet, description) do
      :ok = WalletState.add_wallet(wallet)
      {:ok, Wallet.serialize(wallet, false)}
    end
  end

  # https://developers.circle.com/reference/accounts-wallets-get-id
  @route "/:wallet_id"
  def get_wallet(%{wallet_id: wallet_id}) do
    with {:ok, wallet} <- WalletState.get_wallet(wallet_id) do
      {:ok, Wallet.serialize(wallet, false)}
    end
  end

  # https://developers.circle.com/reference/accounts-wallets-addresses-create
  @route path: "/:wallet_id/addresses", method: :post
  def generate_blockchain_address(%{
        wallet_id: wallet_id,
        idempotencyKey: idempotency_key,
        currency: currency,
        chain: chain
      }) do
    with :ok <- check_idempotency_key(idempotency_key),
         {:ok, address} <- WalletState.new_address(chain, currency) do
      :ok = WalletState.add_address_to_wallet(wallet_id, address)
      {:ok, Address.serialize(address, false)}
    end
  end

  # https://developers.circle.com/reference/accounts-wallets-addresses-get
  @route "/:wallet_id/addresses"
  def list_addresses(%{wallet_id: wallet_id}) do
    with {:ok, wallet} <- WalletState.get_wallet(wallet_id) do
      {:ok, Enum.map(wallet.addresses, fn address -> Address.serialize(address, false) end)}
    end
  end
end
