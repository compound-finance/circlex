defmodule Circlex.Emulator.Api.Accounts.WalletsApiTest do
  use Circlex.ApiCase
  alias Circlex.Emulator.Api.Accounts.WalletsApi
  doctest WalletsApi

  test "create_wallet/1" do
    assert {:ok,
            %{
              balances: [],
              description: "My Wallet",
              entityId: "5dfa1127-050b-4ba6-b9b5-b2015aa4c882",
              type: :end_user_wallet,
              walletId: "1000000500"
            }} ==
             WalletsApi.create_wallet(%{idempotencyKey: UUID.uuid1(), description: "My Wallet"})
  end

  test "list_wallets/1" do
    assert {:ok,
            [
              %{
                balances: [%{amount: "150234.93", currency: "USD"}],
                entityId: "5dfa1127-050b-4ba6-b9b5-b2015aa4c882",
                description: "Master Wallet",
                type: "merchant",
                walletId: "1000216185"
              },
              %{
                balances: [%{amount: "50.00", currency: "USD"}],
                description: "end_user_wallet",
                entityId: "5dfa1127-050b-4ba6-b9b5-b2015aa4c882",
                type: "merchant",
                walletId: "1000216186"
              }
            ]} == WalletsApi.list_wallets(%{})
  end

  test "get_wallet/1" do
    assert {:ok,
            %{
              balances: [%{amount: "150234.93", currency: "USD"}],
              entityId: "5dfa1127-050b-4ba6-b9b5-b2015aa4c882",
              description: "Master Wallet",
              type: "merchant",
              walletId: "1000216185"
            }} == WalletsApi.get_wallet(%{wallet_id: "1000216185"})
  end

  test "generate_blockchain_address/1" do
    assert {:ok,
            %{
              address: "0x6a9de7df6a986a0398348efb0ecd91f341547b31",
              chain: "ETH",
              currency: "USD"
            }} ==
             WalletsApi.generate_blockchain_address(%{
               idempotencyKey: UUID.uuid1(),
               wallet_id: "1000216185",
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
             WalletsApi.list_addresses(%{wallet_id: "1000216185"})
  end
end
