defmodule Circlex.Emulator.Plug do
  use Plug.Router

  # if Mix.env() == :dev do
  #   use Plug.Debugger
  # end

  use Plug.ErrorHandler

  plug(:match)
  plug(:dispatch)

  forward("/ping", to: Circlex.Emulator.Api.HealthApi)
  forward("/v1/configuration", to: Circlex.Emulator.Api.ManagementApi)
  forward("/circlex", to: Circlex.Emulator.Api.CirclexApi)

  get "/" do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(%{message: "Welcome to the Circlex Emulator 🦦"}))
  end

  defp handle_errors(conn, a = %{kind: _kind, reason: reason, stack: _stack}) do
    failure_reason =
      case reason do
        %FunctionClauseError{function: function} ->
          if String.contains?(to_string(function), "match") do
            :not_found
          end

        _ ->
          nil
      end

    case failure_reason do
      :not_found ->
        send_resp(conn, 404, Jason.encode!(%{error: "not found"}))

      _ ->
        send_resp(conn, 500, Jason.encode!(%{error: "internal server error"}))
    end
  end
end
