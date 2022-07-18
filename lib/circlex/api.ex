defmodule Circlex.Api do
  @moduledoc """
  Core API...
  """

  def env_host(), do: Application.get_env(:circlex, :host)

  def not_implemented(), do: {:error, %{error: "Not implemented by Circlex client"}}

  def api_get(path, opts) do
    api_request(:get, path, nil, opts)
  end

  def api_post(path, params, opts) do
    api_request(:post, path, params, opts)
  end

  def api_delete(path, opts) do
    api_request(:delete, path, nil, opts)
  end

  # TODO: Handle errors better
  defp api_request(method, path, params, opts) do
    host = Keyword.get(opts, :host, env_host())
    no_data_key = Keyword.get(opts, :no_data_key, false)

    request = %HTTPoison.Request{
      method: method,
      url: Path.join(host, path),
      body: if(params, do: Jason.encode!(params), else: <<>>),
      headers: [{"Content-Type", "application/json"}, {"Accept", "application/json"}]
    }

    case HTTPoison.request(request) do
      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
        with {:ok, json} <- Jason.decode(body) do
          case status_code do
            code when code in 200..299 ->
              if no_data_key do
                {:ok, json}
              else
                case json do
                  %{"data" => data} ->
                    {:ok, data}

                  _ ->
                    {:error, %{error: "Expected data key, but not given", response: json}}
                end
              end

            _ ->
              case json do
                %{"error" => error} ->
                  {:error, %{error: error}}

                _ ->
                  {:error, json}
              end
          end
        end

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, %{reason: to_string(reason)}}
    end
  end
end
