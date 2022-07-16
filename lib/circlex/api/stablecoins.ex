defmodule Circlex.Api.Stablecoins do
  @moduledoc """
  Core API...
  """
  import Circlex.Api

  @doc ~S"""
  Retrieves total circulating supply for supported stablecoins across all chains.

  Reference: https://developers.circle.com/reference/getstablecoins

  ## Examples

      iex> host = Circlex.Test.start_server()
      iex> Circlex.Api.Stablecoins.get_stablecoins(host: host)
      {:error, %{error: "Not implemented by Circlex client"}}
  """
  def get_stablecoins(opts \\ []) do
    not_implemented()
  end
end
