defmodule Circlex.Emulator.Api.Accounts.WalletsApiTest do
  use Circlex.ApiCase
  alias Circlex.Emulator.Api.Accounts.WalletsApi
  doctest WalletsApi

  test "create_wallet/1" do
    assert {:ok,
            %{
              balances: [],
              description: "My Wallet",
              entityId: "a033a6d8-05ae-11ed-9e62-6a1733211c00",
              type: :end_user_wallet,
              walletId: "1000000500"
            }} ==
             WalletsApi.create_wallet(%{idempotencyKey: UUID.uuid1(), description: "My Wallet"})
  end

  test "list_wallets/1" do
    assert {:ok,
            [
              %{
                balances: [],
                entityId: "5dfa1127-050b-4ba6-b9b5-b2015aa4c882",
                description: "Master Wallet",
                type: "merchant",
                walletId: "1000216185"
              }
            ]} == WalletsApi.list_wallets(%{})
  end

  test "get_wallet/1" do
    assert {:ok,
            %{
              balances: [],
              entityId: "5dfa1127-050b-4ba6-b9b5-b2015aa4c882",
              description: "Master Wallet",
              type: "merchant",
              walletId: "1000216185"
            }} == WalletsApi.get_wallet(%{wallet_id: 1_000_216_185})
  end
end
