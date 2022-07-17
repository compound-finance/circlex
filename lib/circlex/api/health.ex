defmodule Circlex.Api.Health do
  @moduledoc """
  Core API...
  """
  import Circlex.Api

  @doc ~S"""
  Pings a server to check connectivity.

  Reference: https://developers.circle.com/reference/ping

  ## Examples

      iex> host = Circlex.Test.start_server()
      iex> Circlex.Api.Health.ping(host: host)
      {:ok, %{message: "pong"}}
  """
  def ping(opts \\ []) do
    case api_get("/ping", Keyword.put(opts, :no_data_key, true)) do
      {:ok, %{"message" => message}} ->
        {:ok, %{message: message}}

      {:error, error} ->
        {:error, error}
    end
  end
end
