defmodule Circlex.Emulator.Api.ManagementApiTest do
  use Circlex.ApiCase
  doctest Circlex.Emulator.Api.ManagementApi

  alias Circlex.Emulator.Api.ManagementApi
  alias Circlex.Emulator.State.Wallet

  test "gets the master wallet" do
    {:ok, config} = ManagementApi.get_config(%{})
    assert config == %{payments: %{masterWalletId: "1000216185"}}
  end
end
