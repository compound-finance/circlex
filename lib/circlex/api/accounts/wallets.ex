defmodule Circlex.Api.Accounts.Wallets do
  @moduledoc """
  Core API...
  """
  import Circlex.Api
  alias Circlex.Objects.Wallet

  @doc ~S"""
  Creates an end user wallet.

  Reference: https://developers.circle.com/reference/accounts-wallets-create

  ## Examples

      iex> host = Circlex.Test.start_server(next: %{uuid: ["4b8a0908-05a2-11ed-899c-6a1733211c18"], wallet_id: [1000955467]})
      iex> Circlex.Api.Accounts.Wallets.create("Test Wallet", host: host)
      {
        :ok,
        %Circlex.Objects.Wallet{
          balances: [],
          description: "Test Wallet",
          entity_id: "4b8a0908-05a2-11ed-899c-6a1733211c18",
          type: "end_user_wallet",
          wallet_id: 1000955467
        }
      }
  """
  def create(description, opts \\ []) do
    idempotency_key = Keyword.get(opts, :idempotency_key, UUID.uuid1())

    case api_post(
           "/v1/wallets",
           %{idempotencyKey: idempotency_key, description: description},
           opts
         ) do
      {:ok,
       %{
         "walletId" => wallet_id,
         "entityId" => entity_id,
         "type" => type,
         "description" => description,
         "balances" => balances
       }} ->
        {:ok,
         %Wallet{
           wallet_id: wallet_id,
           entity_id: entity_id,
           type: type,
           description: description,
           balances: balances
         }}
    end
  end

  @doc ~S"""
  Retrieves a list of a user's wallets.

  Reference: https://developers.circle.com/reference/accounts-wallets-get

  ## Examples

      iex> host = Circlex.Test.start_server()
      iex> Circlex.Api.Accounts.Wallets.list_wallets(host: host)
      {
        :ok,
        [
          %Circlex.Objects.Wallet{
            balances: [],
            description: "Master Wallet",
            entity_id: "5dfa1127-050b-4ba6-b9b5-b2015aa4c882",
            type: "merchant",
            wallet_id: "1000216185"
          }
        ]
      }
  """
  def list_wallets(opts \\ []) do
    with {:ok, wallets} <- api_get("/v1/wallets", opts) do
      {:ok, Enum.map(wallets, &Wallet.deserialize/1)}
    end
  end

  @doc ~S"""
  Get a wallet

  Reference: https://developers.circle.com/reference/accounts-wallets-get-id

  ## Examples

      iex> host = Circlex.Test.start_server()
      iex> Circlex.Api.Accounts.Wallets.get_wallet(1000216185, host: host)
      {
        :ok,
        %Circlex.Objects.Wallet{
          balances: [],
          description: "Master Wallet",
          entity_id: "5dfa1127-050b-4ba6-b9b5-b2015aa4c882",
          type: "merchant",
          wallet_id: "1000216185"
        }
      }
  """
  def get_wallet(id, opts \\ []) do
    with {:ok, wallet} <- api_get(Path.join("/v1/wallets", to_string(id)), opts) do
      {:ok, Wallet.deserialize(wallet)}
    end
  end

  @doc ~S"""
  Generate a blockchain address

  Reference: https://developers.circle.com/reference/accounts-wallets-addresses-create

  ## Examples

      iex> host = Circlex.Test.start_server()
      iex> Circlex.Api.Accounts.Wallets.generate_address(host: host)
      {:error, %{error: "Not implemented by Circlex client"}}
  """
  def generate_address(opts \\ []) do
    not_implemented()
  end

  @doc ~S"""
  Retrieves a list of addresses associated with a wallet.

  Reference: https://developers.circle.com/reference/accounts-wallets-addresses-get

  ## Examples

      iex> host = Circlex.Test.start_server()
      iex> Circlex.Api.Accounts.Wallets.list_addresses(host: host)
      {:error, %{error: "Not implemented by Circlex client"}}
  """
  def list_addresses(opts \\ []) do
    not_implemented()
  end
end
