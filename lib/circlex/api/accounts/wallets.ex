defmodule Circlex.Api.Accounts.Wallets do
  @moduledoc """
  Core API...
  """
  import Circlex.Api
  alias Circlex.Struct.Wallet

  @doc ~S"""
  Creates an end user wallet.

  Reference: https://developers.circle.com/reference/accounts-wallets-create

  ## Examples

      iex> host = Circlex.Test.start_server()
      iex> Circlex.Api.Accounts.Wallets.create("Test Wallet", host: host)
      {
        :ok,
        %Circlex.Struct.Wallet{
          balances: [],
          description: "Test Wallet",
          entity_id: "5dfa1127-050b-4ba6-b9b5-b2015aa4c882",
          type: "end_user_wallet",
          wallet_id: "1000000500"
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
          %Circlex.Struct.Wallet{
            addresses: [],
            balances: [%Circlex.Struct.Amount{amount: "150234.93", currency: "USD"}],
            description: "Master Wallet",
            entity_id: "5dfa1127-050b-4ba6-b9b5-b2015aa4c882",
            type: "merchant",
            wallet_id: "1000216185"
          },
           %Circlex.Struct.Wallet{
            addresses: [],
            balances: [%Circlex.Struct.Amount{amount: "50.00", currency: "USD"}],
            description: "end_user_wallet",
            entity_id: "5dfa1127-050b-4ba6-b9b5-b2015aa4c882",
            type: "merchant",
            wallet_id: "1000216186"
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
      iex> Circlex.Api.Accounts.Wallets.get_wallet("1000216185", host: host)
      {
        :ok,
        %Circlex.Struct.Wallet{
          balances: [%Circlex.Struct.Amount{amount: "150234.93", currency: "USD"}],
          description: "Master Wallet",
          entity_id: "5dfa1127-050b-4ba6-b9b5-b2015aa4c882",
          type: "merchant",
          wallet_id: "1000216185",
          addresses: [],
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
      iex> Circlex.Api.Accounts.Wallets.generate_address("1000216185", "USD", "ETH", host: host)
      {:ok,
        %{
          address: "0x6a9de7df6a986a0398348efb0ecd91f341547b31",
          chain: "ETH",
          currency: "USD"
        }}
  """
  def generate_address(wallet_id, currency, chain, opts \\ []) do
    idempotency_key = Keyword.get(opts, :idempotency_key, UUID.uuid1())

    case api_post(
           Path.join(["/v1/wallets", wallet_id, "addresses"]),
           %{idempotencyKey: idempotency_key, currency: currency, chain: chain},
           opts
         ) do
      {:ok,
       %{
         "address" => address,
         "chain" => chain,
         "currency" => currency
       }} ->
        {:ok,
         %{
           address: address,
           chain: chain,
           currency: currency
         }}
    end
  end

  @doc ~S"""
  Retrieves a list of addresses associated with a wallet.

  Reference: https://developers.circle.com/reference/accounts-wallets-addresses-get

  ## Examples

      iex> host = Circlex.Test.start_server()
      iex> Circlex.Api.Accounts.Wallets.list_addresses("1000216185", host: host)
      {
        :ok,
        [
          %{address: "0x522c4caaf435fdf1822c7b6a081858344623cf84", chain: "ETH", currency: "USD"},
          %{address: "mpLQ2waXiQW6aAtnp9XMWh52R42k3QVjtU", chain: "BTC", currency: "BTC"},
          %{address: "0x6a9de7df6a986a0398348efb0ecd91f341547b31", chain: "ETH", currency: "USD"}
        ]
      }
  """
  def list_addresses(wallet_id, opts \\ []) do
    with {:ok, addresses} <- api_get(Path.join(["/v1/wallets", wallet_id, "addresses"]), opts) do
      {:ok,
       Enum.map(addresses, fn %{
                                "address" => address,
                                "chain" => chain,
                                "currency" => currency
                              } ->
         %{address: address, chain: chain, currency: currency}
       end)}
    end
  end
end
