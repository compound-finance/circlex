defmodule Circlex.Emulator.Api.Core.BalancesApiTest do
  use Circlex.ApiCase
  alias Circlex.Emulator.Api.Core.BalancesApi
  doctest BalancesApi

  test "get_balances/1" do
    assert {:ok, %{available: [], unsettled: []}} == BalancesApi.get_balances(%{})
  end
end
