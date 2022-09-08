defmodule Circlex.Struct.BeneficiaryBank do
  use Circlex.Struct.JasonHelper
import Circlex.Struct.Util

  defstruct [
    :account_number,
    :address,
    :city,
    :country,
    :currency,
    :name,
    :postal_code,
    :routing_number,
    :swift_code
  ]

  def deserialize(beneficiary_bank) do
    %__MODULE__{
      account_number: fetch(beneficiary_bank, :accountNumber),
      address: fetch(beneficiary_bank, :address),
      city: fetch(beneficiary_bank, :city),
      country: fetch(beneficiary_bank, :country),
      currency: fetch(beneficiary_bank, :currency),
      name: fetch(beneficiary_bank, :name),
      postal_code: fetch(beneficiary_bank, :postalCode),
      routing_number: fetch(beneficiary_bank, :routingNumber),
      swift_code: fetch(beneficiary_bank, :swiftCode)
    }
  end

  def serialize(beneficiary_bank) do
    %{
      accountNumber: beneficiary_bank.account_number,
      address: beneficiary_bank.address,
      city: beneficiary_bank.city,
      country: beneficiary_bank.country,
      currency: beneficiary_bank.currency,
      name: beneficiary_bank.name,
      postalCode: beneficiary_bank.postal_code,
      routingNumber: beneficiary_bank.routing_number,
      swiftCode: beneficiary_bank.swift_code
    }
  end
end
