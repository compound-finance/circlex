defmodule Circlex.Struct.WireInstructions do
  use Circlex.Struct.JasonHelper
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

  def serialize(wire_instructions) do
    %{
      beneficiary: fetch(wire_instructions, :beneficiary),
      beneficiaryBank: BeneficiaryBank.serialize(fetch(wire_instructions, :beneficiary_bank)),
      trackingRef: fetch(wire_instructions, :tracking_ref),
      virtualAccountEnabled: fetch(wire_instructions, :virtual_account_enabled)
    }
  end

  # Constructs wire instructions from a bank account given its id and tracking_ref
  def from_bank_account(bank_account = %Circlex.Struct.BankAccount{}) do
    <<virtual_account_number::binary-size(12)>> <> _rest =
      :binary.decode_unsigned(bank_account.id) |> Integer.to_string()

    beneficiary_bank = %{
      account_number: virtual_account_number,
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
