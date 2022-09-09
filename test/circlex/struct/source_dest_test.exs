defmodule Circlex.Struct.SourceDestTest do
  use ExUnit.Case
  alias Circlex.Struct.{Amount, SourceDest, SourceDest.Identity, Payout, PhysicalAddress}

  @source_dest %SourceDest{
    id: "12345",
    identities: [
      %Identity{
        addresses: [
          %PhysicalAddress{
            city: "San Franciso",
            country: "US",
            district: "CA",
            line1: "1460 Mission St. Unit 02-121",
            line2: nil,
            postal_code: "94103"
          }
        ],
        name: "Compound Prime",
        type: "business"
      }
    ],
    type: :wallet
  }

  @source_dest_ser %{
    id: "12345",
    identities: [
      %{
        addresses: [
          %{
            city: "San Franciso",
            country: "US",
            district: "CA",
            line1: "1460 Mission St. Unit 02-121",
            line2: nil,
            postalCode: "94103"
          }
        ],
        name: "Compound Prime",
        type: "business"
      }
    ],
    type: "wallet"
  }

  describe "deserialize" do
    test "normal" do
      assert SourceDest.deserialize(@source_dest_ser) == @source_dest
    end
  end

  describe "serialize" do
    test "normal" do
      assert SourceDest.serialize(@source_dest) ==
               @source_dest_ser
    end
  end

  describe "JasonEncoding" do
    test "it calls serialize then jason.encode" do
      assert Jason.encode(@source_dest) ==
               Jason.encode(@source_dest_ser)
    end
  end
end
