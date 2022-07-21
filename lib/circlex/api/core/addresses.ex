defmodule Circlex.Api.Core.Addresses do
  @moduledoc """
  API Client to the Circle Core Addresses API.

  For example, to create a deposit address:

  ```elixir
  > Circlex.Api.Core.Addresses.generate_deposit_address("USD", "ETH")
  {:ok,
    %{
      address: "0x6a9DE7dF6a986a0398348EFB0ECD91f341547b31",
      chain: "ETH",
      currency: "USD"
    }}
  ```

  To get a list of deposit addresses:

  ```elixir
  > Circlex.Api.Core.Addresses.list_deposit_addresses()
  {
    :ok,
    [
      %{address: "0x522C4caaf435FDF1822C7b6A081858344623Cf84", chain: "ETH", currency: "USD"},
      %{address: "mpLQ2waXiQW6aAtnp9XMWh52R42k3QVjtU", chain: "BTC", currency: "BTC"},
      %{address: "0x6a9DE7dF6a986a0398348EFB0ECD91f341547b31", chain: "ETH", currency: "USD"}
    ]
  }
  ```

  Or to add a recipient address:

  ```elixir
  > Circlex.Api.Core.Addresses.add_recipient_address("0x9999999999999999999999999999999999999999", "USD", "ETH", "Nines", host: host)
  {:ok,
    %Circlex.Struct.Recipient{
      address: "0x9999999999999999999999999999999999999999",
      chain: "ETH",
      currency: "USD",
      description: "Nines",
      id: "a033a6d8-05ae-11ed-9e62-6a1733211c00"
    }}
  ```

  Reference: https://developers.circle.com/reference/generatebusinessaccountdepositaddress
  """

  import Circlex.Api.Tooling

  alias Circlex.Struct.Recipient

  @doc ~S"""
  Generates a new blockchain address for a wallet for a given currency/chain pair.

  Reference: https://developers.circle.com/reference/generatebusinessaccountdepositaddress

  ## Examples

      iex> host = Circlex.Test.start_server()
      iex> Circlex.Api.Core.Addresses.generate_deposit_address("USD", "ETH", host: host)
      {:ok,
        %{
          address: "0x6a9DE7dF6a986a0398348EFB0ECD91f341547b31",
          chain: "ETH",
          currency: "USD"
        }}
  """
  def generate_deposit_address(currency, chain, opts \\ []) do
    idempotency_key = Keyword.get(opts, :idempotency_key, UUID.uuid1())

    case api_post(
           "/v1/businessAccount/wallets/addresses/deposit",
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
  Get a list of deposit addresses.

  Reference: https://developers.circle.com/reference/getbusinessaccountdepositaddresses

  ## Examples

      iex> host = Circlex.Test.start_server()
      iex> Circlex.Api.Core.Addresses.list_deposit_addresses(host: host)
      {
        :ok,
        [
          %{address: "0x522C4caaf435FDF1822C7b6A081858344623Cf84", chain: "ETH", currency: "USD"},
          %{address: "mpLQ2waXiQW6aAtnp9XMWh52R42k3QVjtU", chain: "BTC", currency: "BTC"},
          %{address: "0x6a9DE7dF6a986a0398348EFB0ECD91f341547b31", chain: "ETH", currency: "USD"}
        ]
      }
  """
  def list_deposit_addresses(opts \\ []) do
    with {:ok, addresses} <- api_get("/v1/businessAccount/wallets/addresses/deposit", opts) do
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

  @doc ~S"""
  Stores an external blockchain address.

  Reference: https://developers.circle.com/reference/createbusinessaccountrecipientaddress

  ## Examples

      iex> host = Circlex.Test.start_server()
      iex> Circlex.Api.Core.Addresses.add_recipient_address("0x9999999999999999999999999999999999999999", "USD", "ETH", "Nines", host: host)
      {:ok,
        %Circlex.Struct.Recipient{
          address: "0x9999999999999999999999999999999999999999",
          chain: "ETH",
          currency: "USD",
          description: "Nines",
          id: "a033a6d8-05ae-11ed-9e62-6a1733211c00"
        }}
  """
  def add_recipient_address(address, currency, chain, description, opts \\ []) do
    idempotency_key = Keyword.get(opts, :idempotency_key, UUID.uuid1())

    case api_post(
           "/v1/businessAccount/wallets/addresses/recipient",
           %{
             idempotencyKey: idempotency_key,
             address: address,
             currency: currency,
             chain: chain,
             description: description
           },
           opts
         ) do
      {:ok,
       %{
         "id" => id,
         "address" => address,
         "chain" => chain,
         "currency" => currency,
         "description" => description
       }} ->
        {:ok,
         %Recipient{
           id: id,
           address: address,
           chain: chain,
           currency: currency,
           description: description
         }}
    end
  end

  @doc ~S"""
  Get a list of verified recipient addresses.

  Reference: https://developers.circle.com/reference/getbusinessaccountrecipientaddresses

  ## Examples

      iex> host = Circlex.Test.start_server()
      iex> Circlex.Api.Core.Addresses.list_recipient_address(host: host)
      {
        :ok,
        [
          %Circlex.Struct.Recipient{
            address: "0x9dfb4F706A4747355A7Ef65cd341a0289034A385",
            chain: "ETH",
            currency: "USD",
            description: "Treasury Adaptor v1",
            id: "7bfd6d2a-3682-52b5-a041-714af6913086"
          },
          %Circlex.Struct.Recipient{
            address: "0x2Eb953F992D4fa6E769FABf25D8218f21b793558",
            chain: "ETH",
            currency: "USD",
            description: "Fireblocks Address",
            id: "b2cef1b0-6c54-52b8-9d62-71b85f5b51ed"
          }
        ]
      }
  """
  def list_recipient_address(opts \\ []) do
    with {:ok, recipients} <- api_get("/v1/businessAccount/wallets/addresses/recipient", opts) do
      {:ok,
       Enum.map(recipients, fn %{
                                 "id" => id,
                                 "address" => address,
                                 "chain" => chain,
                                 "currency" => currency,
                                 "description" => description
                               } ->
         %Recipient{
           id: id,
           address: address,
           chain: chain,
           currency: currency,
           description: description
         }
       end)}
    end
  end
end
