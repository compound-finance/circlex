defmodule Circlex.Emulator.Api.ManagementApiTest do
  use Circlex.ApiCase
  doctest Circlex.Emulator.Api.ManagementApi

  alias Circlex.Emulator.Api.ManagementApi

  test "gets the master wallet" do
    {:ok, config} = ManagementApi.get_config(%{})
    assert config == %{payments: %{masterWalletId: "1000216185"}}
  end

  @tag load: false
  test "fails to get master wallet when not loaded" do
    assert {:error, "System Configuration Issue: no main \"merchant\" wallet specified"} ==
             ManagementApi.get_config(%{})
  end
end
