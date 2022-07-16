defmodule Circlex.Emulator.Api.HealthApi do
  @moduledoc """
  Mounted under `/ping`.
  """
  use Circlex.Emulator.Api

  # https://developers.circle.com/reference/ping
  @route "/"
  def ping(%{}) do
    {:ok, %{message: "pong"}}
  end

end
