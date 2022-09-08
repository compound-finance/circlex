defmodule Circlex.Struct.BeneficiaryBankTest do
  use ExUnit.Case
  alias Circlex.Struct.BeneficiaryBank

  @beneficiary_bank %BeneficiaryBank{
    account_number: "198906493711",
    address: "1 MONEY STREET",
    city: "NEW YORK",
    country: "US",
    currency: "USD",
    name: "CRYPTO BANK",
    postal_code: "1001",
    routing_number: "999999999",
    swift_code: "CRYPTO99"
  }

  @beneficiary_bank_ser %{
    accountNumber: "198906493711",
    address: "1 MONEY STREET",
    city: "NEW YORK",
    country: "US",
    currency: "USD",
    name: "CRYPTO BANK",
    postalCode: "1001",
    routingNumber: "999999999",
    swiftCode: "CRYPTO99"
  }

  describe "deserialize" do
    test "success" do
      assert BeneficiaryBank.deserialize(@beneficiary_bank_ser) == @beneficiary_bank
    end
  end

  describe "serialize" do
    test "success" do
      assert BeneficiaryBank.serialize(@beneficiary_bank) == @beneficiary_bank_ser
    end
  end

    
  describe "JasonEncoding" do
    test "it calls serialize then jason.encode" do
      assert Jason.encode(@beneficiary_bank) == Jason.encode(@beneficiary_bank_ser)
    end
  end
end
