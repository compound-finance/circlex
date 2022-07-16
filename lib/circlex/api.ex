defmodule Circlex.Api do
  @moduledoc """
  Core API...
  """

  defp env_host(), do: Application.get_env(:circlex, :host)

  @doc ~S"""
  Pings a server to check connectivity.

  Reference: https://developers.circle.com/reference/ping

  ## Examples

      iex> host = Circlex.Test.start_server()
      iex> Circlex.Api.ping(host: host)
      {:ok, %{message: "pong"}}
  """
  def ping(opts \\ []) do
    case api_get("/ping", opts) do
      {:ok, %{"message" => message}} ->
        {:ok, %{message: message}}

      {:error, error} ->
        {:error, error}
    end
  end

  @doc ~S"""
  Retrieves general configuration information.

  Reference: https://developers.circle.com/reference/getconfig

  ## Examples

      iex> host = Circlex.Test.start_server()
      iex> Circlex.Api.getconfig(host: host)
      {:ok, %{payments: %{master_wallet_id: "1000216185"}}}

      iex> host = Circlex.Test.start_server(no_load: true)
      iex> Circlex.Api.getconfig(host: host)
      {:error, %{"error" => "System Configuration Issue: no main \"merchant\" wallet specified"}}
  """
  def getconfig(opts \\ []) do
    case api_get("/v1/configuration", opts) do
      {:ok, %{"payments" => %{"masterWalletId" => master_wallet_id}}} ->
        {:ok, %{payments: %{master_wallet_id: master_wallet_id}}}

      {:error, error} ->
        {:error, error}
    end
  end

  defp api_get(path, opts) do
    host = Keyword.get(opts, :host, env_host())

    case HTTPoison.get(Path.join(host, path)) do
      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
        with {:ok, json} <- Jason.decode(body) do
          case status_code do
            code when code in 200..299 ->
              {:ok, json}

            _ ->
              {:error, json}
          end
        end

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, %{reason: to_string(reason)}}
    end
  end
end
