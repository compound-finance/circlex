defmodule Circlex.Emulator.Api.Core.AddressesApi do
  @moduledoc """
  Mounted under `/v1/businessAccount/wallet/addresses`.
  """
  use Circlex.Emulator.Api
  alias Circlex.Emulator.Api
  alias Circlex.Emulator.State.RecipientState
  alias Circlex.Struct.Recipient

  @route path: "/deposit", method: :post
  def generate_deposit_address(%{
        idempotencyKey: idempotency_key,
        currency: currency,
        chain: chain
      }) do
    with {:ok, master_wallet} <- get_master_wallet() do
      Api.Accounts.WalletsApi.generate_blockchain_address(%{
        wallet_id: master_wallet.wallet_id,
        idempotencyKey: idempotency_key,
        currency: currency,
        chain: chain
      })
    end
  end

  # https://developers.circle.com/reference/getbusinessaccountdepositaddresses
  @route "/deposit"
  def list_deposit_addresses(%{}) do
    with {:ok, master_wallet} <- get_master_wallet() do
      Api.Accounts.WalletsApi.list_addresses(%{
        wallet_id: master_wallet.wallet_id
      })
    end
  end

  # https://developers.circle.com/reference/createbusinessaccountrecipientaddress
  @route path: "/recipient", method: :post
  def add_recipient_address(%{
        address: address,
        chain: chain,
        currency: currency,
        description: description
      }) do
    # TODO: Check idempotency key

    with {:ok, recipient} <- RecipientState.new_recipient(address, chain, currency, description) do
      RecipientState.add_recipient(recipient)
      {:ok, Recipient.serialize(recipient)}
    end
  end

  # https://developers.circle.com/reference/getbusinessaccountrecipientaddresses
  @route "/recipient"
  def list_recipient_addresses(%{}) do
    {:ok, Enum.map(RecipientState.all(), &Recipient.serialize/1)}
  end
end
