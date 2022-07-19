defmodule Circlex.Emulator.Api.Accounts.WalletsApi do
  @moduledoc """
  Mounted under `/v1/wallets`.
  """
  use Circlex.Emulator.Api
  alias Circlex.Emulator.State.WalletState
  alias Circlex.Struct.Wallet

  # https://developers.circle.com/reference/accounts-wallets-get
  @route "/"
  def list_wallets(%{}) do
    {:ok, Enum.map(WalletState.all_wallets(), &Wallet.serialize(&1, false))}
  end

  # https://developers.circle.com/reference/accounts-wallets-create
  @route path: "/", method: :post
  def create_wallet(%{idempotencyKey: idempotency_key, description: description}) do
    # TODO: Check idempotency key

    with {:ok, wallet} <- WalletState.new_wallet(:end_user_wallet, description) do
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
    # TODO: Check idempotency key
    address = %{
      address: "0x6a9de7df6a986a0398348efb0ecd91f341547b31",
      currency: currency,
      chain: chain
    }

    WalletState.update_wallet(wallet_id, fn wallet ->
      %{wallet | addresses: [address | wallet.addresses]}
    end)

    {:ok, address}
  end

  # https://developers.circle.com/reference/accounts-wallets-addresses-get
  @route "/:wallet_id/addresses"
  def list_addresses(%{wallet_id: wallet_id}) do
    with {:ok, wallet} <- WalletState.get_wallet(wallet_id) do
      {:ok, Wallet.serialize(wallet)[:addresses]}
    end
  end
end
