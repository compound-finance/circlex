defmodule Circlex.Emulator.State.WalletStateTest do
  use ExUnit.Case
  alias Circlex.Emulator.State.WalletState
  alias Circlex.Emulator.State
  alias Circlex.Struct.{Address, Amount, Wallet}
  doctest WalletState

  @wallet %Wallet{
    addresses: [
      %Address{
        address: "0x522c4caaf435fdf1822c7b6a081858344623cf84",
        chain: "ETH",
        currency: "USD"
      },
      %Address{
        address: "mpLQ2waXiQW6aAtnp9XMWh52R42k3QVjtU",
        chain: "BTC",
        currency: "BTC"
      },
      %Address{
        address: "0x6a9de7df6a986a0398348efb0ecd91f341547b31",
        chain: "ETH",
        currency: "USD"
      }
    ],
    balances: [%Amount{amount: "150234.93", currency: "USD"}],
    description: "Master Wallet",
    entity_id: "5dfa1127-050b-4ba6-b9b5-b2015aa4c882",
    type: "merchant",
    wallet_id: "1000216185"
  }

  setup do
    {:ok, state_pid} = State.start_link(Circlex.Test.get_opts())
    Process.put(:state_pid, state_pid)

    :ok
  end

  test "all_wallets/0" do
    assert Enum.member?(WalletState.all_wallets(), @wallet)
  end

  describe "get_wallet/1" do
    test "found" do
      assert {:ok, @wallet} == WalletState.get_wallet(@wallet.wallet_id)
    end

    test "not found" do
      assert :not_found == WalletState.get_wallet("55")
    end
  end

  describe "get_wallet_by_address/1" do
    test "found" do
      assert {:ok, @wallet} ==
               WalletState.get_wallet_by_address(
                 "BTC",
                 "BTC",
                 "mpLQ2waXiQW6aAtnp9XMWh52R42k3QVjtU"
               )
    end

    test "not found" do
      assert :not_found ==
               WalletState.get_wallet_by_address(
                 "BTC",
                 "USD",
                 "mpLQ2waXiQW6aAtnp9XMWh52R42k3QVjtU"
               )
    end
  end

  test "master_wallet/0" do
    assert {:ok, @wallet} == WalletState.master_wallet()
  end

  test "add_wallet/1" do
    WalletState.all_wallets()
    new_wallet = %{@wallet | wallet_id: "1000216186"}
    WalletState.add_wallet(new_wallet)
    assert [^new_wallet | _] = WalletState.all_wallets()
  end

  test "update_wallet/1" do
    WalletState.update_wallet(@wallet.wallet_id, fn wallet -> %{wallet | description: "cool"} end)
    assert {:ok, %{@wallet | description: "cool"}} == WalletState.get_wallet(@wallet.wallet_id)
  end
end
