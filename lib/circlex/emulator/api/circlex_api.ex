defmodule Circlex.Emulator.Api.CirclexApi do
  @moduledoc """
  Mounted under `/circlex`.
  """
  use Circlex.Emulator.Api

  @route path: "/save/:path", method: :post
  def save(%{path: path}) do
    if path =~ ~r/^[a-zA-Z][a-zA-Z0-9_-]{1,50}$/ do
      file = Path.join("state", "#{path}.json")
      State.persist({:file, file})
      {:ok, %{saved: file}}
    else
      {:error, "Invalid state name, should match ^[a-zA-Z][a-zA-Z0-9_-]{1,50}$"}
    end
  end
end
