defmodule Circlex.Emulator.Api.MocksApiTest do
  use Circlex.ApiCase
  alias Circlex.Emulator.Api.MocksApi
  alias Circlex.Emulator.State.WalletState
  alias Circlex.Struct.Wallet
  doctest MocksApi

  test "create_mock_wire/1" do
    {:ok, master_wallet} = WalletState.master_wallet()
    assert Wallet.get_balance(master_wallet, "USD") == "150234.93"

    assert {:ok,
            %{
              amount: %{amount: "100.00", currency: "USD"},
              status: "pending",
              trackingRef: "CIR3KX3L99",
              beneficiaryBank: %{
                accountNumber: "1000000001"
              }
            }} ==
             MocksApi.create_mock_wire(%{
               trackingRef: "CIR3KX3L99",
               amount: %{amount: "100.00", currency: "USD"},
               beneficiaryBank: %{
                 accountNumber: "1000000001"
               }
             })

    # allow effects
    :timer.sleep(2000)

    {:ok, master_wallet} = WalletState.master_wallet()
    assert Wallet.get_balance(master_wallet, "USD") == "150334.93"
  end
end
