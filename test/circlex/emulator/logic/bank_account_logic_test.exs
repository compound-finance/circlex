defmodule Circlex.Emulator.Logic.BankAccountLogicTest do
  use ExUnit.Case
  alias Circlex.Emulator.Logic.BankAccountLogic
  alias Circlex.Struct.BankAccount
  doctest BankAccountLogic

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
    bank_accounts = [@bank_account]

    {:ok, %{bank_accounts: bank_accounts}}
  end

  test "get_bank_account/2", %{bank_accounts: bank_accounts} do
    assert {:ok, @bank_account} ==
             BankAccountLogic.get_bank_account(
               bank_accounts,
               @bank_account.id
             )
  end

  test "add_bank_account/2", %{bank_accounts: bank_accounts} do
    new_bank_account = %{@bank_account | id: "new"}

    assert {:ok, [new_bank_account, @bank_account]} ==
             BankAccountLogic.add_bank_account(
               bank_accounts,
               new_bank_account
             )
  end

  describe "update_bank_account/3" do
    test "setting bank_account", %{bank_accounts: bank_accounts} do
      updated_bank_account = %{@bank_account | description: "cool"}

      assert {:ok, [updated_bank_account]} ==
               BankAccountLogic.update_bank_account(bank_accounts, @bank_account.id, fn _ ->
                 updated_bank_account
               end)
    end
  end
end
