defmodule Circlex.Struct.AddressTest do
  use ExUnit.Case
  alias Circlex.Struct.Address

  @address %Address{
    address: "0x5d2e4a271103100c8dd463a3229e9fbb7e079f50",
    chain: "ETH",
    currency: "USD",
    priv_key: "0x8abc75661d0adc4c92ffe0bd93aa7b75f5e9cb361dad42c4a99441e8dfeb4cdf"
  }

  @address_ser_priv %{
    address: "0x5d2e4a271103100c8dd463a3229e9fbb7e079f50",
    chain: "ETH",
    currency: "USD",
    privKey: "0x8abc75661d0adc4c92ffe0bd93aa7b75f5e9cb361dad42c4a99441e8dfeb4cdf"
  }

  @address_ser_no_priv %{
    address: "0x5d2e4a271103100c8dd463a3229e9fbb7e079f50",
    chain: "ETH",
    currency: "USD"
  }

  describe "deserialize" do
    test "with priv key" do
      assert Address.deserialize(@address_ser_priv) == @address
    end

    test "without priv key" do
      assert Address.deserialize(@address_ser_no_priv) == %{@address | priv_key: nil}
    end
  end

  describe "serialize" do
    test "with priv key" do
      assert Address.serialize(@address) == @address_ser_priv
    end

    test "without priv key" do
      assert Address.serialize(@address, false) == @address_ser_no_priv
    end
  end

  describe "JasonEncoding" do
    test "it calls serialize then jason.encode" do
      assert Jason.encode(@address) == Jason.encode(@address_ser_priv)
    end
  end
end
