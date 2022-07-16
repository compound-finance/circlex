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
        json_decoder: {Jason, :decode!, [[keys: :atoms]]}
      )
    end
  end

  def define_route(%{module: module}, kind, name, _args, _guards, _body) do
    case Module.get_attribute(module, :route) do
      path when is_binary(path) ->
        Module.put_attribute(module, :__routes__, {path, :get, name})
        Module.put_attribute(module, :route, nil)

      [path: path, method: method] ->
        Module.put_attribute(module, :__routes__, {path, method, name})
        Module.put_attribute(module, :route, nil)

      _ ->
        nil
    end
  end

  defmacro define_routes(%{module: module}) do
    for {route, method, fun} <- Module.get_attribute(module, :__routes__) do
      quote bind_quoted: [module: module, fun: fun, route: route, method: method] do
        use Plug.Router

        match route, via: method do
          Process.put(:state_pid, var!(conn).private[:state_pid])
          params = Circlex.Emulator.Api.api_params(var!(conn))

          apply(unquote(module), unquote(fun), [params])
          |> Circlex.Emulator.Api.api_handle(var!(conn))
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
    conn.params
  end

  def api_handle(res, conn) do
    case res do
      {:ok, val} ->
        json!(val, conn)

      {:error, error} ->
        json!(%{error: to_string(error)}, conn, 500)
    end
  end
end
