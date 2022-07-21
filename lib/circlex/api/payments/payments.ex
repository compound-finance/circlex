defmodule Circlex.Api.Payments.Payments do
  @moduledoc """
  API Client to the Payments Payments API.

  Reference: https://developers.circle.com/reference/payments-payments-get
  """

  import Circlex.Api.Tooling

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
            amount: %Circlex.Struct.Amount{amount: "3.14", currency: "USD"},
            create_date: "2022-07-15T21:10:03.635Z",
            description: "Merchant Push Payment",
            fees: %Circlex.Struct.Amount{amount: "2.00", currency: "USD"},
            id: "24c26e1b-8666-46fa-96ea-892afcadb9bb",
            merchant_id: "5dfa1127-050b-4ba6-b9b5-b2015aa4c882",
            merchant_wallet_id: "1000216185",
            refunds: [],
            source: %Circlex.Struct.SourceDest{
              address: nil,
              address_id: nil,
              address_tag: nil,
              chain: nil,
              id: "ad823515-3b51-4061-a016-d626e3cd105e",
              type: :wire
            },
            status: "paid",
            type: "payment",
            update_date: "2022-07-15T21:11:03.863523Z"
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
      iex> Circlex.Api.Payments.Payments.get_payment("24c26e1b-8666-46fa-96ea-892afcadb9bb", host: host)
      {
        :ok,
        %Circlex.Struct.Payment{
          amount: %Circlex.Struct.Amount{amount: "3.14", currency: "USD"},
          create_date: "2022-07-15T21:10:03.635Z",
          description: "Merchant Push Payment",
          fees: %Circlex.Struct.Amount{amount: "2.00", currency: "USD"},
          id: "24c26e1b-8666-46fa-96ea-892afcadb9bb",
          merchant_id: "5dfa1127-050b-4ba6-b9b5-b2015aa4c882",
          merchant_wallet_id: "1000216185",
          refunds: [],
          source: %Circlex.Struct.SourceDest{
            address: nil,
            address_id: nil,
            address_tag: nil,
            chain: nil,
            id: "ad823515-3b51-4061-a016-d626e3cd105e",
            type: :wire
          },
          status: "paid",
          type: "payment",
          update_date: "2022-07-15T21:11:03.863523Z"
        }
      }
  """
  def get_payment(id, opts \\ []) do
    with {:ok, payment} <- api_get(Path.join("/v1/payments", to_string(id)), opts) do
      {:ok, Payment.deserialize(payment)}
    end
  end
end
