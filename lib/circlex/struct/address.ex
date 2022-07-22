defmodule Circlex.Struct.Address do
  import Circlex.Struct.Util

  defstruct [:chain, :currency, :address, :priv_key]

  def deserialize(address) do
    %__MODULE__{
      chain: fetch(address, :chain),
      currency: fetch(address, :currency),
      address: fetch(address, :address),
      priv_key: fetch(address, :privKey)
    }
  end

  def serialize(address, include_priv_key \\ true) do
    Map.merge(
      %{
        chain: address.chain,
        currency: address.currency,
        address: address.address
      },
      if(include_priv_key && !is_nil(address.priv_key),
        do: %{privKey: String.downcase(address.priv_key)},
        else: %{}
      )
    )
  end

  def match?(address_struct = %__MODULE__{}, chain, currency, address) do
    str_eq(address_struct.chain, chain) and str_eq(address_struct.currency, currency) and
      str_eq(address_struct.address, address)
  end

  defp str_eq(a, b) do
    String.downcase(a) == String.downcase(b)
  end
end
