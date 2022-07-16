defmodule Circlex.Emulator.Api.HealthApiTest do
  use Circlex.ApiCase
  alias Circlex.Emulator.Api.HealthApi
  doctest HealthApi

  test "ping/1" do
    assert {:ok, %{message: "pong"}} = HealthApi.ping(%{})
  end
end
