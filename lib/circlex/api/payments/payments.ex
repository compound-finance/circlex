defmodule Circlex.Api.Payments.Payments do
  @moduledoc """
  Core API...
  """
  import Circlex.Api
  alias Circlex.Struct.Payment

  @doc ~S"""
  Get a list of payments.

  Reference: https://developers.circle.com/reference/payments-payments-get

  # TODO: Filters

  ## Examples

      iex> host = Circlex.Test.start_server()
      iex> Circlex.Api.Payments.Payments.list_payments(host: host)
      {
        :ok,
        [
          %Circlex.Struct.Payment{
            adjustments: nil,
            amount: %Circlex.Struct.Amount{amount: "12111.00", currency: "USD"},
            create_date: "2022-07-15T20:03:32.718Z",
            destination: %Circlex.Struct.SourceDest{id: "4847be95-8b73-44cc-a329-549a25a776e2", name: "CAIXABANK, S.A. ****6789", type: :wire},
            fees: %Circlex.Struct.Amount{amount: "25.00", currency: "USD"},
            id: "5e2e20bd-6ad6-4603-950b-64803647a4e5",
            return: nil,
            risk_evaluation: nil,
            source_wallet_id: "1000788811",
            status: "complete",
            tracking_ref: nil,
            update_date: "2022-07-15T20:20:32.255Z"
          },
          %Circlex.Struct.Payment{
            adjustments: nil,
            amount: %Circlex.Struct.Amount{amount: "12111.00", currency: "USD"},
            create_date: "2022-07-15T20:03:32.718Z",
            destination: %Circlex.Struct.SourceDest{
              id: "4847be95-8b73-44cc-a329-549a25a776e2",
              name: "CAIXABANK, S.A. ****6789",
              type: :wire
            },
            fees: %Circlex.Struct.Amount{amount: "25.00", currency: "USD"},
            id: "6e2e20bd-6ad6-4603-950b-64803647a4e6",
            return: nil,
            risk_evaluation: nil,
            source_wallet_id: "1000216185",
            status: "complete",
            tracking_ref: nil,
            update_date: "2022-07-15T20:20:32.255Z"
          }
        ]
      }
  """
  def list_payments(opts \\ []) do
    with {:ok, payments} <- api_get("/v1/payments", opts) do
      {:ok, Enum.map(payments, &Payment.deserialize/1)}
    end
  end

  @doc ~S"""
  Get a payment.

  Reference: https://developers.circle.com/reference/payments-payments-get-id

  ## Examples

      iex> host = Circlex.Test.start_server()
      iex> Circlex.Api.Payments.Payments.get_payment("5e2e20bd-6ad6-4603-950b-64803647a4e5", host: host)
      {
        :ok,
        %Circlex.Struct.Payment{
          adjustments: nil,
          amount: %Circlex.Struct.Amount{amount: "12111.00", currency: "USD"},
          create_date: "2022-07-15T20:03:32.718Z",
          destination: %{id: "4847be95-8b73-44cc-a329-549a25a776e2", name: "CAIXABANK, S.A. ****6789", type: :wire},
          fees: %Circlex.Struct.Amount{amount: "25.00", currency: "USD"},
          id: "5e2e20bd-6ad6-4603-950b-64803647a4e5",
          return: nil,
          risk_evaluation: nil,
          source_wallet_id: "1000788811",
          status: "complete",
          tracking_ref: nil,
          update_date: "2022-07-15T20:20:32.255Z"
        }
      }
  """
  def get_payment(id, opts \\ []) do
    with {:ok, payment} <- api_get(Path.join("/v1/payments", to_string(id)), opts) do
      {:ok, Payment.deserialize(payment)}
    end
  end
end
