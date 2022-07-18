defmodule Circlex.Emulator.Api.Core.PayoutsApiTest do
  use ExUnit.Case
  doctest Circlex.Emulator.Api.Core.PayoutsApi

  alias Circlex.Emulator.Api.Core.PayoutsApi
  alias Circlex.Emulator.State.Payout

  test "create and retrieve a payout" do
    {:ok, payout} = PayoutsApi.create(%{destination: "abc", amount: 123})
    # TODO: Test some properties on the payout

    assert {:ok, ^payout} = PayoutsApi.get(payout.id)
  end
end
