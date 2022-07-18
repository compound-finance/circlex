defmodule Circlex.Emulator.Api.Core.AddressesApiTest do
  use Circlex.ApiCase
  alias Circlex.Emulator.Api.Core.AddressesApi
  doctest AddressesApi

  test "generate_blockchain_address/1" do
    assert {:ok,
            %{
              address: "0x6a9de7df6a986a0398348efb0ecd91f341547b31",
              chain: "ETH",
              currency: "USD"
            }} ==
             AddressesApi.generate_deposit_address(%{
               idempotencyKey: UUID.uuid1(),
               currency: "USD",
               chain: "ETH"
             })
  end

  test "list_addresses/1" do
    assert {:ok,
            [
              %{
                address: "0x522c4caaf435fdf1822c7b6a081858344623cf84",
                chain: "ETH",
                currency: "USD"
              },
              %{address: "mpLQ2waXiQW6aAtnp9XMWh52R42k3QVjtU", chain: "BTC", currency: "BTC"},
              %{
                address: "0x6a9de7df6a986a0398348efb0ecd91f341547b31",
                chain: "ETH",
                currency: "USD"
              }
            ]} ==
             AddressesApi.list_deposit_addresses(%{})
  end

  test "add_recipient_address/1" do
    assert {:ok,
            %{
              address: "0x9999999999999999999999999999999999999999",
              chain: "ETH",
              currency: "USD",
              description: "Nines",
              id: "a033a6d8-05ae-11ed-9e62-6a1733211c00"
            }} ==
             AddressesApi.add_recipient_address(%{
               idempotencyKey: UUID.uuid1(),
               address: "0x9999999999999999999999999999999999999999",
               currency: "USD",
               chain: "ETH",
               description: "Nines"
             })
  end

  test "list_recipient_address/1" do
    assert {:ok,
            [
              %{
                address: "0x9dfb4f706a4747355a7ef65cd341a0289034a385",
                chain: "ETH",
                currency: "USD",
                description: "Treasury Adaptor v1",
                id: "7bfd6d2a-3682-52b5-a041-714af6913086"
              },
              %{
                address: "0x2eb953f992d4fa6e769fabf25d8218f21b793558",
                chain: "ETH",
                currency: "USD",
                description: "Fireblocks Address",
                id: "b2cef1b0-6c54-52b8-9d62-71b85f5b51ed"
              }
            ]} ==
             AddressesApi.list_recipient_addresses(%{})
  end
end
