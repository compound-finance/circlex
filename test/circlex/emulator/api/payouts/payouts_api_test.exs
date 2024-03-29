defmodule Circlex.Emulator.Api.Payouts.PayoutsApiTest do
  use Circlex.ApiCase
  alias Circlex.Emulator.Api.Payouts.PayoutsApi
  alias Circlex.Emulator.State
  alias State.WalletState
  alias Circlex.Struct.Wallet
  doctest PayoutsApi

  test "create_payout/1" do
    {:ok, master_wallet} = WalletState.master_wallet()
    assert Wallet.get_balance(master_wallet, "USD") == "150234.93"

    assert {:ok,
            %{
              amount: %{amount: "100.00", currency: "USD"},
              createDate: "2022-07-17T08:59:41.344582Z",
              destination: %{
                type: "wire",
                id: "4847be95-8b73-44cc-a329-549a25a776e2"
              },
              id: "a033a6d8-05ae-11ed-9e62-6a1733211c00",
              status: "pending",
              fees: %{amount: "0.00", currency: "USD"},
              sourceWalletId: "1000216185",
              trackingRef: "CIR3KXZZ00",
              updateDate: "2022-07-17T08:59:41.344582Z"
            }} ==
             PayoutsApi.create_payout(%{
               idempotencyKey: UUID.uuid1(),
               source: %{id: "1000216185", type: "wallet"},
               destination: %{
                 type: "wire",
                 id: "4847be95-8b73-44cc-a329-549a25a776e2",
                 name: "CAIXABANK, S.A. ****6789"
               },
               amount: %{amount: "100.00", currency: "USD"},
               metadata: %{beneficiaryEmail: "tom@example.com"}
             })

    # Allow processing time
    :timer.sleep(2 * Circlex.Emulator.action_delay())

    {:ok, master_wallet} = WalletState.master_wallet()
    assert Wallet.get_balance(master_wallet, "USD") == "150134.93"
  end

  test "list_payouts/1" do
    assert {:ok,
            [
              %{
                amount: %{amount: "12111.00", currency: "USD"},
                createDate: "2022-07-15T20:03:32.718Z",
                destination: %{
                  type: "wire",
                  id: "4847be95-8b73-44cc-a329-549a25a776e2"
                },
                id: "5e2e20bd-6ad6-4603-950b-64803647a4e5",
                status: "complete",
                fees: %{amount: "25.00", currency: "USD"},
                sourceWalletId: "1000788811",
                trackingRef: nil,
                updateDate: "2022-07-15T20:20:32.255Z"
              },
              %{
                amount: %{amount: "12111.00", currency: "USD"},
                createDate: "2022-07-15T20:03:32.718Z",
                destination: %{
                  id: "4847be95-8b73-44cc-a329-549a25a776e2",
                  type: "wire"
                },
                fees: %{amount: "25.00", currency: "USD"},
                id: "6e2e20bd-6ad6-4603-950b-64803647a4e6",
                sourceWalletId: "1000216185",
                status: "complete",
                trackingRef: nil,
                updateDate: "2022-07-15T20:20:32.255Z"
              }
            ]} == PayoutsApi.list_payouts(%{})
  end

  test "get_payout/1" do
    assert {:ok,
            %{
              amount: %{amount: "12111.00", currency: "USD"},
              createDate: "2022-07-15T20:03:32.718Z",
              destination: %{
                type: "wire",
                id: "4847be95-8b73-44cc-a329-549a25a776e2"
              },
              id: "5e2e20bd-6ad6-4603-950b-64803647a4e5",
              status: "complete",
              fees: %{amount: "25.00", currency: "USD"},
              sourceWalletId: "1000788811",
              trackingRef: nil,
              updateDate: "2022-07-15T20:20:32.255Z"
            }} ==
             PayoutsApi.get_payout(%{payout_id: "5e2e20bd-6ad6-4603-950b-64803647a4e5"})
  end
end
