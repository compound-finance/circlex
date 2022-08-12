defmodule Circlex.Struct.WireInstructions do
  import Circlex.Struct.Util

  alias Circlex.Struct.BeneficiaryBank

  defstruct [
    :beneficiary,
    :beneficiary_bank,
    :tracking_ref,
    :virtual_account_enabled
  ]

  def deserialize(wire_instructions) do
    %__MODULE__{
      beneficiary: fetch(wire_instructions, :beneficiary),
      beneficiary_bank: BeneficiaryBank.deserialize(fetch(wire_instructions, :beneficiaryBank)),
      tracking_ref: fetch(wire_instructions, :trackingRef),
      virtual_account_enabled: fetch(wire_instructions, :virtualAccountEnabled)
    }
  end

  # Takes a BankAccount for serializing
  def serialize_bank_account(bank_account = %Circlex.Struct.BankAccount{}) do
    beneficiary_bank = %{
      account_number: bank_account.virtual_account_number,
      address: "1 MONEY STREET",
      city: "NEW YORK",
      country: "US",
      currency: "USD",
      name: "CRYPTO BANK",
      postal_code: "1001",
      routing_number: "999999999",
      swift_code: "CRYPTO99"
    }

    %{
      beneficiary: %{
        address1: "1 MAIN STREET",
        address2: "SUITE 1",
        name: "CIRCLE INTERNET FINANCIAL INC"
      },
      beneficiaryBank: BeneficiaryBank.serialize(beneficiary_bank),
      trackingRef: bank_account.tracking_ref,
      virtualAccountEnabled: true
    }
  end
end
