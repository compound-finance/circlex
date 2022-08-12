defmodule Circlex.Struct.WireInstructionsTest do
  use ExUnit.Case
  alias Circlex.Struct.{BankAccount, WireInstructions, BeneficiaryBank}

  @wire_instructions %WireInstructions{
    beneficiary: %{
      address1: "1 MAIN STREET",
      address2: "SUITE 1",
      name: "CIRCLE INTERNET FINANCIAL INC"
    },
    beneficiary_bank: %BeneficiaryBank{
      account_number: "547425368404",
      address: "1 MONEY STREET",
      city: "NEW YORK",
      country: "US",
      currency: "USD",
      name: "CRYPTO BANK",
      postal_code: "1001",
      routing_number: "999999999",
      swift_code: "CRYPTO99"
    },
    tracking_ref: "CIR3KX3L99",
    virtual_account_enabled: true
  }

  @bank_account %BankAccount{
    id: "fce6d303-2923-43cf-a66a-1e4690e08d1b",
    status: "complete",
    description: "HSBC Canada ****4444",
    tracking_ref: "CIR3KX3L99",
    fingerprint: "b296029f-8ec2-49bf-9b11-22ba09973c49",
    billing_details: %{
      name: "Satoshi Nakamoto",
      line1: "100 Money St",
      city: "Toronto",
      postal_code: "ON M5J 1S9",
      district: "ON",
      country: "CA"
    },
    bank_address: %{
      bank_name: "HSBC Canada",
      city: "Toronto",
      country: "CA"
    },
    create_date: "2022-02-14T22:29:32.779Z",
    update_date: "2022-02-14T22:29:33.516Z",
    virtual_account_number: "547425368404"
  }

  @wire_instructions_ser %{
    beneficiary: %{
      address1: "1 MAIN STREET",
      address2: "SUITE 1",
      name: "CIRCLE INTERNET FINANCIAL INC"
    },
    beneficiaryBank: %{
      accountNumber: "547425368404",
      address: "1 MONEY STREET",
      city: "NEW YORK",
      country: "US",
      currency: "USD",
      name: "CRYPTO BANK",
      postalCode: "1001",
      routingNumber: "999999999",
      swiftCode: "CRYPTO99"
    },
    trackingRef: "CIR3KX3L99",
    virtualAccountEnabled: true
  }

  describe "deserialize" do
    test "success" do
      assert WireInstructions.deserialize(@wire_instructions_ser) == @wire_instructions
    end
  end

  describe "serialize" do
    test "success" do
      assert WireInstructions.serialize_bank_account(@bank_account) == @wire_instructions_ser
    end
  end
end
