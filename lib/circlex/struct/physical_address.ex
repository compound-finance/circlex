defmodule Circlex.Struct.PhysicalAddress do
  @moduledoc """
  Transfer beneficiaries need a physical address for travel rule requirements
  References: https://www.circle.com/blog/introducing-the-travel-rule-universal-solution-technology
  """
  use Circlex.Struct.JasonHelper
  import Circlex.Struct.Util

  defstruct [:line1, :line2, :city, :district, :postal_code, :country]

  def deserialize(physical_address) do
    %__MODULE__{
      line1: fetch(physical_address, :line1),
      line2: fetch(physical_address, :line2),
      city: fetch(physical_address, :city),
      district: fetch(physical_address, :district),
      postal_code: fetch(physical_address, :postalCode),
      country: fetch(physical_address, :country)
    }
  end

  def serialize(physical_address) do
    %{
      line1: physical_address.line1,
      line2: physical_address.line2,
      city: physical_address.city,
      district: physical_address.district,
      postalCode: physical_address.postal_code,
      country: physical_address.country
    }
  end
end
