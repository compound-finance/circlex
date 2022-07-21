defmodule Circlex.Api.Management do
  @moduledoc """
  API Client to the Management API.

  Reference: https://developers.circle.com/reference/getconfig
  """

  import Circlex.Api.Tooling

  @doc ~S"""
  Retrieves general configuration information.

  Reference: https://developers.circle.com/reference/getconfig

  ## Examples

      iex> host = Circlex.Test.start_server()
      iex> Circlex.Api.Management.get_config(host: host)
      {:ok, %{payments: %{master_wallet_id: "1000216185"}}}

      iex> host = Circlex.Test.start_server(no_load: true)
      iex> Circlex.Api.Management.get_config(host: host)
      {:error, %{error: "System Configuration Issue: no main \"merchant\" wallet specified"}}
  """
  def get_config(opts \\ []) do
    with {:ok, %{"payments" => %{"masterWalletId" => master_wallet_id}}} <-
           api_get("/v1/configuration", opts) do
      {:ok, %{payments: %{master_wallet_id: master_wallet_id}}}
    end
  end
end
