defmodule Circlex.Api.Core.Addresses do
  @moduledoc """
  Core API...
  """
  import Circlex.Api
  alias Circlex.Struct.Wallet

  @doc ~S"""
  Generates a new blockchain address for a wallet for a given currency/chain pair.

  Reference: https://developers.circle.com/reference/generatebusinessaccountdepositaddress

  ## Examples

      iex> host = Circlex.Test.start_server()
      iex> Circlex.Api.Core.Addresses.generate_deposit_address("USD", "ETH", host: host)
      {:ok,
        %{
          address: "0x6a9de7df6a986a0398348efb0ecd91f341547b31",
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
          %{address: "0x522c4caaf435fdf1822c7b6a081858344623cf84", chain: "ETH", currency: "USD"},
          %{address: "mpLQ2waXiQW6aAtnp9XMWh52R42k3QVjtU", chain: "BTC", currency: "BTC"},
          %{address: "0x6a9de7df6a986a0398348efb0ecd91f341547b31", chain: "ETH", currency: "USD"}
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
end
