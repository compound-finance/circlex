defmodule Circlex.Emulator.State.BankAccountStateTest do
  use ExUnit.Case
  alias Circlex.Emulator.State.BankAccountState
  alias Circlex.Emulator.State
  alias Circlex.Struct.BankAccount
  doctest BankAccountState

  @bank_account %BankAccount{
    description: "HSBC Canada ****4444",
    bank_address: %{bankName: "HSBC Canada", city: "Toronto", country: "CA"},
    billing_details: %{
      city: "Toronto",
      country: "CA",
      district: "ON",
      line1: "100 Money St",
      name: "Satoshi Nakamoto",
      postalCode: "ON M5J 1S9"
    },
    create_date: "2022-02-14T22:29:32.779Z",
    fingerprint: "b296029f-8ec2-49bf-9b11-22ba09973c49",
    id: "fce6d303-2923-43cf-a66a-1e4690e08d1b",
    status: "complete",
    tracking_ref: "CIR3KX3L99",
    update_date: "2022-02-14T22:29:33.516Z",
    virtual_account_number: "547425368404" 
  }

  setup do
    {:ok, state_pid} = State.start_link(Circlex.Test.get_opts())
    Process.put(:state_pid, state_pid)

    :ok
  end

  test "all_bank_accounts/0" do
    assert Enum.member?(BankAccountState.all_bank_accounts(), @bank_account)
  end

  describe "get_bank_account/1" do
    test "found" do
      assert {:ok, @bank_account} ==
               BankAccountState.get_bank_account(@bank_account.id)
    end

    test "not found" do
      assert :not_found == BankAccountState.get_bank_account("55")
    end
  end

  test "add_bank_account/1" do
    BankAccountState.all_bank_accounts()
    new_bank_account = %{@bank_account | id: @bank_account.id}
    BankAccountState.add_bank_account(new_bank_account)
    assert [^new_bank_account | _] = BankAccountState.all_bank_accounts()
  end

  test "update_bank_account/1" do
    BankAccountState.update_bank_account(@bank_account.id, fn bank_account ->
      %{bank_account | description: "cool"}
    end)

    assert {:ok, %{@bank_account | description: "cool"}} ==
             BankAccountState.get_bank_account(@bank_account.id)
  end
end
