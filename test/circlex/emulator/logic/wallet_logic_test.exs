defmodule Circlex.Emulator.Logic.WalletLogicTest do
  use ExUnit.Case
  alias Circlex.Emulator.Logic.WalletLogic
  alias Circlex.Struct.{Address, Amount, Wallet}
  doctest WalletLogic

  @wallet %Wallet{
    balances: [%Amount{amount: "150234.93", currency: "USD"}],
    description: "Master Wallet",
    entity_id: "5dfa1127-050b-4ba6-b9b5-b2015aa4c882",
    type: "merchant",
    wallet_id: "1000216185",
    addresses: [
      %Address{
        chain: "ETH",
        currency: "USD",
        address: "0x522c4caaf435fdf1822c7b6a081858344623cf84"
      }
    ]
  }

  setup do
    wallets = [@wallet]

    {:ok, %{wallet_0: @wallet, wallets: wallets}}
  end

  test "get_wallet/2", %{wallets: wallets} do
    assert {:ok, @wallet} == WalletLogic.get_wallet(wallets, "1000216185")
  end

  describe "get_wallet_by_address/2" do
    test "found", %{wallets: wallets} do
      assert {:ok, @wallet} ==
               WalletLogic.get_wallet_by_address(
                 wallets,
                 "ETH",
                 "USD",
                 "0x522c4caaf435fdf1822c7b6a081858344623cf84"
               )
    end

    test "not found", %{wallets: wallets} do
      assert :not_found ==
               WalletLogic.get_wallet_by_address(
                 wallets,
                 "ETH",
                 "ETH",
                 "0x522c4caaf435fdf1822c7b6a081858344623cf84"
               )
    end
  end

  test "master_wallet/1", %{wallets: wallets} do
    assert {:ok, @wallet} == WalletLogic.master_wallet(wallets)
  end

  test "add_wallet/2", %{wallets: wallets} do
    new_wallet = %{@wallet | wallet_id: "1000216186"}
    assert {:ok, [new_wallet, @wallet]} == WalletLogic.add_wallet(wallets, new_wallet)
  end

  describe "update_balance/2" do
    test "existing balance", %{wallets: wallets} do
      assert {:ok,
              [
                %Wallet{
                  balances: [%Amount{amount: "151234.93", currency: "USD"}],
                  description: "Master Wallet",
                  entity_id: "5dfa1127-050b-4ba6-b9b5-b2015aa4c882",
                  type: "merchant",
                  wallet_id: "1000216185",
                  addresses: [
                    %Address{
                      chain: "ETH",
                      currency: "USD",
                      address: "0x522c4caaf435fdf1822c7b6a081858344623cf84"
                    }
                  ]
                }
              ]} ==
               WalletLogic.update_balance(wallets, @wallet.wallet_id, %Amount{
                 currency: "USD",
                 amount: "1000.00"
               })
    end

    test "new balance", %{wallets: wallets} do
      assert {:ok,
              [
                %Wallet{
                  addresses: nil,
                  balances: [
                    %Amount{amount: "1000.00", currency: "GBP"},
                    %Amount{amount: "150234.93", currency: "USD"}
                  ],
                  description: "Master Wallet",
                  entity_id: "5dfa1127-050b-4ba6-b9b5-b2015aa4c882",
                  type: "merchant",
                  wallet_id: "1000216185",
                  addresses: [
                    %Address{
                      chain: "ETH",
                      currency: "USD",
                      address: "0x522c4caaf435fdf1822c7b6a081858344623cf84"
                    }
                  ]
                }
              ]} ==
               WalletLogic.update_balance(wallets, @wallet.wallet_id, %Amount{
                 currency: "GBP",
                 amount: "1000.00"
               })
    end
  end

  describe "update_wallet/3" do
    test "setting wallet", %{wallets: wallets} do
      updated_wallet = %{@wallet | description: "cool"}

      assert {:ok, [updated_wallet]} ==
               WalletLogic.update_wallet(wallets, @wallet.wallet_id, updated_wallet)
    end

    test "updating wallet", %{wallets: wallets} do
      updated_wallet = %{@wallet | description: "cool"}

      assert {:ok, [updated_wallet]} ==
               WalletLogic.update_wallet(wallets, @wallet.wallet_id, fn _ ->
                 updated_wallet
               end)
    end
  end
end
