defmodule Circlex.Emulator.Router do
  use Plug.Router
  require Logger

  def call(conn, opts) do
    conn
    |> put_private(:state_pid, Keyword.get(opts, :state_pid))
    |> put_private(:signer_proc, Keyword.get(opts, :signer_proc))
    |> super(opts)
  end

  # if Mix.env() == :dev do
  #   use Plug.Debugger
  # end

  use Plug.ErrorHandler

  plug(:match)
  plug(:dispatch)

  forward("/circlex", to: Circlex.Emulator.Api.CirclexApi)
  forward("/v1/mocks", to: Circlex.Emulator.Api.MocksApi)

  # Base
  forward("/ping", to: Circlex.Emulator.Api.HealthApi)
  forward("/v1/configuration", to: Circlex.Emulator.Api.ManagementApi)
  forward("/v1/stablecoins", to: Circlex.Emulator.Api.StablecoinsApi)
  forward("/v1/notifications/subscriptions", to: Circlex.Emulator.Api.SubscriptionsApi)

  # Core
  forward("/v1/businessAccount/balances", to: Circlex.Emulator.Api.Core.BalancesApi)
  forward("/v1/businessAccount/payouts", to: Circlex.Emulator.Api.Core.PayoutsApi)
  forward("/v1/businessAccount/banks", to: Circlex.Emulator.Api.Core.BankAccountsApi)
  forward("/v1/businessAccount/transfers", to: Circlex.Emulator.Api.Core.TransfersApi)
  forward("/v1/businessAccount/wallets/addresses", to: Circlex.Emulator.Api.Core.AddressesApi)
  # forward("/v1/businessAccount/deposits", to: Circlex.Emulator.Api.Core.DepositsApi)

  # Payments API
  forward("/v1/payments", to: Circlex.Emulator.Api.Payments.PaymentsApi)
  # Mirrors /v1/banks

  # Payouts
  forward("/v1/payouts", to: Circlex.Emulator.Api.Payouts.PayoutsApi)
  forward("/v1/banks", to: Circlex.Emulator.Api.Core.BankAccountsApi)
  forward("/v1/transfers", to: Circlex.Emulator.Api.Payouts.TransfersApi)
  # forward("/v1/returns", to: Circlex.Emulator.Api.Payouts.ReturnsApi)

  # Accounts
  forward("/v1/wallets", to: Circlex.Emulator.Api.Accounts.WalletsApi)
  # Mirrors /v1/transfers

  get "/" do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(%{message: "Welcome to the Circlex Emulator 🦦🪨"}))
  end

  defp handle_errors(conn, error = %{kind: _kind, reason: reason, stack: _stack}) do
    Logger.error(inspect(error))

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
