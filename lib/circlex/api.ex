defmodule Circlex.Api do
  @moduledoc """
  Core API...
  """

  def env_host(), do: Application.get_env(:circlex, :host)

  def not_implemented(), do: {:error, %{error: "Not implemented by Circlex client"}}

  def api_get(path, opts) do
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
