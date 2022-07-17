defmodule Circlex.Emulator.Api do
  import Plug.Conn

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
        use Plug.Router

        match route, via: method do
          parser_opts = [parsers: [:json], json_decoder: Jason]

          conn = Plug.Parsers.call(var!(conn), Plug.Parsers.init(parser_opts))
          Process.put(:state_pid, conn.private[:state_pid])
          params = Circlex.Emulator.Api.api_params(conn)

          apply(unquote(module), unquote(fun), [params])
          |> Circlex.Emulator.Api.api_handle(conn, unquote(no_data_key))
        end
      end
    end
  end

  def json!(value, conn, status \\ 200) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, Jason.encode!(value))
  end

  def api_params(conn) do
    for {k, v} <- conn.params, into: %{} do
      {String.to_atom(k), v}
    end
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
end
