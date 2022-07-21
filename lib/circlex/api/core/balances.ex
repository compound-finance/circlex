defmodule Circlex.Api.Core.Balances do
  @moduledoc """
  API Client to the Core Balances API.

  References: https://developers.circle.com/reference/getbusinessaccountbalances
  """

  import Circlex.Api.Tooling

  @doc ~S"""
  Retrieves the balance of funds that are available for use.

  Reference: https://developers.circle.com/reference/getbusinessaccountbalances

  ## Examples

      iex> host = Circlex.Test.start_server()
      iex> Circlex.Api.Core.Balances.get_balances(host: host)
      {:ok, %{available: [], unsettled: []}}
  """
  def get_balances(opts \\ []) do
    case api_get("/v1/businessAccount/balances", opts) do
      {:ok,
       %{
         "available" => available,
         "unsettled" => unsettled
       }} ->
        {:ok, %{available: available, unsettled: unsettled}}
    end
  end
end
