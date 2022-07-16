defmodule Circlex.Emulator.Api.Core.PayoutApiTest do
  use ExUnit.Case
  doctest Circlex.Emulator.Api.Core.PayoutApi

  alias Circlex.Emulator.Api.Core.PayoutApi
  alias Circlex.Emulator.State.Payout

  test "create and retrieve a payout" do
    {:ok, payout} = PayoutApi.create(%{destination: "abc", amount: 123})
    # TODO: Test some properties on the payout

    assert {:ok, ^payout} = PayoutApi.get(payout.id)
  end
end
