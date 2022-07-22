defmodule Circlex.Api.Payouts.Payouts do
  @moduledoc """
  API Client to the Payouts Payouts API.

  Reference: https://developers.circle.com/reference/payouts-payouts-create
  """

  import Circlex.Api.Tooling

  alias Circlex.Struct.Payout

  @doc ~S"""
  Create a payout.

  Reference: https://developers.circle.com/reference/payouts-payouts-create

  ## Examples

      iex> host = Circlex.Test.start_server()
      iex> source = %{id: "1000788811", type: "wallet"}
      iex> destination = %{address: "0x871A9FF377eCf2632A0928950dCEb181557F2e17", chain: "ETH", type: "blockchain"}
      iex> amount = %{amount: "12345.00", currency: "USD"}
      iex> metadata = %{beneficiaryEmail: "tom@example.com"}
      iex> Circlex.Api.Payouts.Payouts.create(source, destination, amount, metadata, host: host)
      {
        :ok,
        %Circlex.Struct.Payout{
          adjustments: nil,
          amount: %Circlex.Struct.Amount{amount: "12345.00", currency: "USD"},
          create_date: "2022-07-17T08:59:41.344582Z",
          destination: %Circlex.Struct.SourceDest{address: "0x871a9ff377ecf2632a0928950dceb181557f2e17", chain: "ETH", type: :blockchain},
          fees: %Circlex.Struct.Amount{amount: "0.00", currency: "USD"},
          id: "a033a6d8-05ae-11ed-9e62-6a1733211c00",
          return: nil,
          risk_evaluation: nil,
          source_wallet_id: "1000788811",
          status: "pending",
          tracking_ref: "CIR3KXZZ00",
          update_date: "2022-07-17T08:59:41.344582Z"
        }
      }
  """
  def create(source, destination, amount, metadata, opts \\ []) do
    idempotency_key = Keyword.get(opts, :idempotency_key, UUID.uuid1())

    with {:ok, payout} <-
           api_post(
             "/v1/payouts",
             %{
               idempotencyKey: idempotency_key,
               source: source,
               destination: destination,
               amount: amount,
               metadata: metadata
             },
             opts
           ) do
      {:ok, Payout.deserialize(payout)}
    end
  end

  @doc ~S"""
  Get a list of payouts.

  Reference: https://developers.circle.com/reference/payouts-payouts-get

  # TODO: Filters

  ## Examples

      iex> host = Circlex.Test.start_server()
      iex> Circlex.Api.Payouts.Payouts.list_payouts(host: host)
      {
        :ok,
        [
          %Circlex.Struct.Payout{
            adjustments: nil,
            amount: %Circlex.Struct.Amount{amount: "12111.00", currency: "USD"},
            create_date: "2022-07-15T20:03:32.718Z",
            destination: %Circlex.Struct.SourceDest{id: "4847be95-8b73-44cc-a329-549a25a776e2", type: :wire},
            fees: %Circlex.Struct.Amount{amount: "25.00", currency: "USD"},
            id: "5e2e20bd-6ad6-4603-950b-64803647a4e5",
            return: nil,
            risk_evaluation: nil,
            source_wallet_id: "1000788811",
            status: "complete",
            tracking_ref: nil,
            update_date: "2022-07-15T20:20:32.255Z"
          },
          %Circlex.Struct.Payout{
            adjustments: nil,
            amount: %Circlex.Struct.Amount{amount: "12111.00", currency: "USD"},
            create_date: "2022-07-15T20:03:32.718Z",
            destination: %Circlex.Struct.SourceDest{
              id: "4847be95-8b73-44cc-a329-549a25a776e2",
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
  def list_payouts(opts \\ []) do
    with {:ok, payouts} <- api_get("/v1/payouts", opts) do
      {:ok, Enum.map(payouts, &Payout.deserialize/1)}
    end
  end

  @doc ~S"""
  Get a payout.

  Reference: https://developers.circle.com/reference/payouts-payouts-get-id

  ## Examples

      iex> host = Circlex.Test.start_server()
      iex> Circlex.Api.Payouts.Payouts.get_payout("5e2e20bd-6ad6-4603-950b-64803647a4e5", host: host)
      {
        :ok,
        %Circlex.Struct.Payout{
          adjustments: nil,
          amount: %Circlex.Struct.Amount{amount: "12111.00", currency: "USD"},
          create_date: "2022-07-15T20:03:32.718Z",
          destination: %Circlex.Struct.SourceDest{id: "4847be95-8b73-44cc-a329-549a25a776e2", type: :wire},
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
  def get_payout(id, opts \\ []) do
    with {:ok, payout} <- api_get(Path.join("/v1/payouts", to_string(id)), opts) do
      {:ok, Payout.deserialize(payout)}
    end
  end
end
