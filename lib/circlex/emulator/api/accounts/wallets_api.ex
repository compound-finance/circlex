defmodule Circlex.Emulator.Api.Accounts.WalletsApi do
  @moduledoc """
  Mounted under `/v1/wallets`.
  """
  use Circlex.Emulator.Api
  alias Circlex.Emulator.State.WalletState
  alias Circlex.Objects.Wallet

  # https://developers.circle.com/reference/accounts-wallets-get
  @route "/"
  def list_wallets(%{}) do
    {:ok, Enum.map(WalletState.all(), &Wallet.serialize/1)}
  end

  # https://developers.circle.com/reference/accounts-wallets-create
  @route path: "/", method: :post
  def create_wallet(%{idempotencyKey: idempotency_key, description: description}) do
    # TODO: Check idempotency key

    with {:ok, wallet} <- Wallet.new(:end_user_wallet, description) do
      WalletState.add_wallet(wallet)
      {:ok, Wallet.serialize(wallet)}
    end
  end

  # https://developers.circle.com/reference/accounts-wallets-get-id
  @route "/:wallet_id"
  def get_wallet(%{wallet_id: wallet_id}) do
    with {:ok, wallet} <- WalletState.get(wallet_id) do
      {:ok, Wallet.serialize(wallet)}
    end
  end
end
