defmodule Circlex.Struct.Address do
  import Circlex.Struct.Util

  defstruct [:chain, :currency, :address]

  def deserialize(address) do
    %__MODULE__{
      chain: fetch(address, :chain),
      currency: fetch(address, :currency),
      address: fetch(address, :address)
    }
  end

  def serialize(address) do
    %{
      chain: address.chain,
      currency: address.currency,
      address:
        if(address.chain == "ETH",
          do: Signet.Util.checksum_address(address.address),
          else: address.address
        )
    }
  end

  def match?(address_struct = %__MODULE__{}, chain, currency, address) do
    str_eq(address_struct.chain, chain) and str_eq(address_struct.currency, currency) and
      str_eq(address_struct.address, address)
  end

  defp str_eq(a, b) do
    String.downcase(a) == String.downcase(b)
  end
end
