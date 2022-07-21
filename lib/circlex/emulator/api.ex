defmodule Circlex.Emulator.Api do
  import Plug.Conn

  alias Circlex.Emulator.State.WalletState

  defmacro __using__([]) do
    quote do
      @on_definition {Circlex.Emulator.Api, :define_route}
      @before_compile {Circlex.Emulator.Api, :define_routes}

      Module.register_attribute(__MODULE__, :route, [])
      Module.register_attribute(__MODULE__, :__routes__, accumulate: true)

      use Plug.Router
      alias Circlex.Emulator.State
      import Circlex.Emulator.Api
      require Circlex.Emulator.Api

      plug(:match)
      plug(:dispatch)

      plug(Plug.Parsers,
        parsers: [:json],
        json_decoder: {Jason, :decode!, [[keys: :atomz]]}
      )
    end
  end

  def define_route(%{module: module}, kind, name, _args, _guards, _body) do
    case Module.get_attribute(module, :route) do
      path when is_binary(path) ->
        Module.put_attribute(module, :__routes__, {path, :get, name, false})
        Module.put_attribute(module, :route, nil)

      opts when is_list(opts) ->
        path = Keyword.get(opts, :path)
        method = Keyword.get(opts, :method)
        no_data_key = Keyword.get(opts, :no_data_key, false)
        Module.put_attribute(module, :__routes__, {path, method, name, no_data_key})
        Module.put_attribute(module, :route, nil)

      _ ->
        nil
    end
  end

  defmacro define_routes(%{module: module}) do
    for {route, method, fun, no_data_key} <- Module.get_attribute(module, :__routes__) do
      quote bind_quoted: [
              module: module,
              fun: fun,
              no_data_key: no_data_key,
              route: route,
              method: method
            ] do
        match route, via: method do
          require Logger

          parser_opts = [parsers: [:json], json_decoder: Jason]

          conn = Plug.Parsers.call(var!(conn), Plug.Parsers.init(parser_opts))
          Process.put(:state_pid, conn.private[:state_pid])
          Process.put(:signer_proc, conn.private[:signer_proc])
          params = Circlex.Emulator.Api.api_params(conn)

          Logger.info("#{conn.method} #{conn.request_path}")
          {elapsed, res} = :timer.tc(unquote(module), unquote(fun), [params])
          conn = Circlex.Emulator.Api.api_handle(res, conn, unquote(no_data_key))

          elapsed_str =
            case floor(elapsed / 1000) do
              0 ->
                "#{elapsed}µs"

              els ->
                "#{els}ms"
            end

          case res do
            {:ok, _} ->
              Logger.info("[Success] #{conn.method} #{conn.request_path} (#{elapsed_str})")

            {:error, _} ->
              Logger.error("[Error] #{conn.method} #{conn.request_path} (#{elapsed_str})")
          end

          conn
        end
      end
    end
  end

  def json!(value, conn, status \\ 200) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, Jason.encode!(value))
  end

  defp deep_keys_to_atoms(map) do
    for {k, v} <- map, into: %{} do
      k_sym =
        cond do
          is_binary(k) ->
            String.to_atom(k)

          is_atom(k) ->
            k
        end

      {k_sym, if(is_map(v), do: deep_keys_to_atoms(v), else: v)}
    end
  end

  def api_params(conn) do
    deep_keys_to_atoms(conn.params)
  end

  def api_handle(res, conn, no_data_key) do
    case res do
      {:ok, val} ->
        if no_data_key do
          json!(val, conn)
        else
          json!(%{data: val}, conn)
        end

      {:error, error} ->
        json!(%{error: to_string(error)}, conn, 500)
    end
  end

  def get_master_wallet() do
    with {:ok, master_wallet} <- WalletState.master_wallet() do
      {:ok, master_wallet}
    else
      :not_found ->
        {:error, "System Configuration Issue: no main \"merchant\" wallet specified"}
    end
  end

  def get_master_source() do
    with {:ok, master_wallet} <- get_master_wallet() do
      {:ok, %{type: "wallet", id: master_wallet.wallet_id}}
    end
  end
end
