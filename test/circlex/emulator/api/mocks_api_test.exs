defmodule Circlex.Emulator.Api.MocksApiTest do
  use Circlex.ApiCase
  alias Circlex.Emulator.Api.MocksApi
  alias Circlex.Emulator.State.WalletState
  alias Circlex.Struct.Wallet
  doctest MocksApi

  test "create_mock_wire/1" do
    # TODO: Test effects, such as changing balance
    {:ok, master_wallet} = WalletState.master_wallet()
    assert Wallet.get_balance(master_wallet, "USD") == "150234.93"

    assert {
             :ok,
             %{
               amount: %{amount: "100.00", currency: "USD"},
               description: "Merchant Push Payment",
               fees: %{amount: "2.00", currency: "USD"},
               id: "a033a6d8-05ae-11ed-9e62-6a1733211c00",
               refunds: [],
               source: %{id: "fce6d303-2923-43cf-a66a-1e4690e08d1b", type: "wire"},
               status: "pending",
               type: "payment",
               createDate: "2022-07-17T08:59:41.344582Z",
               merchantId: "5dfa1127-050b-4ba6-b9b5-b2015aa4c882",
               merchantWalletId: "1000216185",
               updateDate: "2022-07-17T08:59:41.344582Z"
             }
           } ==
             MocksApi.create_mock_wire(%{
               trackingRef: "CIR3KX3L99",
               amount: %{amount: "100.00", currency: "USD"}
             })

    # allow effects
    :timer.sleep(2000)

    {:ok, master_wallet} = WalletState.master_wallet()
    assert Wallet.get_balance(master_wallet, "USD") == "150334.93"
  end
end
