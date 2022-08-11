defmodule Circlex.Struct.WireInstructions do
    import Circlex.Struct.Util

    defstruct [
      :beneficiary,
      :beneficiary_bank,
      :tracking_ref,
      :virtual_account_enabled
    ]

    def deserialize(wire_instructions) do
        %__MODULE__{
            beneficiary: fetch(wire_instructions, :beneficiary),
            beneficiary_bank: fetch(wire_instructions, :beneficiaryBank),
            tracking_ref: fetch(wire_instructions, :trackingRef),
            virtual_account_enabled: fetch(wire_instructions, :virtualAccountEnabled)
        }
    end

    # Accepts Struct.BankAccount, since most wire instructions are hard-coded
    def serialize(wire_instructions) do
        %{
            beneficiary: %{
              address1: "1 MAIN STREET",
              address2: "SUITE 1",
              name: "CIRCLE INTERNET FINANCIAL INC"
            },
            beneficiaryBank: %{
              accountNumber: wire_instructions.virtual_account_number,
              address: "1 MONEY STREET",
              city: "NEW YORK",
              country: "US",
              currency: "USD",
              name: "CRYPTO BANK",
              postalCode: "1001",
              routingNumber: "999999999",
              swiftCode: "CRYPTO99"
            },
            trackingRef: wire_instructions.tracking_ref,
            virtualAccountEnabled: true
        }
    end
end