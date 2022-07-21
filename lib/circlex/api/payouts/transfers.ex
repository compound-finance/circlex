defmodule Circlex.Api.Payouts.Transfers do
  @moduledoc """
  Core API...
  """
  import Circlex.Api
  alias Circlex.Struct.{Amount, Transfer}

  @doc ~S"""
  A transfer can be made from an existing funded wallet to a blockchain address or another wallet.

  Reference: https://developers.circle.com/reference/payouts-transfers-create

  ## Examples

      iex> host = Circlex.Test.start_server()
      iex> source = %{id: "1000788811", type: "wallet"}
      iex> destination = %{address: "0x871A9FF377eCf2632A0928950dCEb181557F2e17", chain: "ETH", type: "blockchain"}
      iex> amount = %{amount: "12345.00", currency: "USD"}
      iex> Circlex.Api.Payouts.Transfers.create(source, destination, amount, host: host)
      {
        :ok,
         %Circlex.Struct.Transfer{
          amount: %Circlex.Struct.Amount{amount: "12345.00", currency: "USD"},
          create_date: "2022-07-17T08:59:41.344582Z",
          destination: %Circlex.Struct.SourceDest{address: "0x871A9FF377eCf2632A0928950dCEb181557F2e17", chain: "ETH", type: :blockchain},
          id: "a033a6d8-05ae-11ed-9e62-6a1733211c00",
          source: %Circlex.Struct.SourceDest{id: "1000788811", type: :wallet},
          status: "pending",
          transaction_hash: nil
        }
      }
  """
  def create(source, destination, amount, opts \\ []) do
    idempotency_key = Keyword.get(opts, :idempotency_key, UUID.uuid1())

    with {:ok, transfer} <-
           api_post(
             "/v1/transfers",
             %{
               idempotencyKey: idempotency_key,
               source: source,
               destination: destination,
               amount: amount
             },
             opts
           ) do
      {:ok, Transfer.deserialize(transfer)}
    end
  end

  @doc ~S"""
  Searches for transfers involving the provided wallets.

  Reference: https://developers.circle.com/reference/payouts-transfers-get

  # TODO: Filters

  ## Examples

      iex> host = Circlex.Test.start_server()
      iex> Circlex.Api.Payouts.Transfers.list_transfers(host: host)
      {
        :ok,
        [
          %Circlex.Struct.Transfer{
            amount: %Circlex.Struct.Amount{amount: "12345.00", currency: "USD"},
            create_date: "2022-07-15T23:51:42.729Z",
            destination: %Circlex.Struct.SourceDest{address: "0x871A9FF377eCf2632A0928950dCEb181557F2e17", chain: "ETH", type: :blockchain},
            id: "588aa258-51c4-4a69-a3bc-88f007375364",
            source: %Circlex.Struct.SourceDest{id: "1000788811", type: :wallet},
            status: "complete",
            transaction_hash: "0x69c8f26c43ec6028c785ab64083758857719806a444135d978c6e730f565ad18"
          },
          %Circlex.Struct.Transfer{
            amount: %Circlex.Struct.Amount{amount: "8999998.14", currency: "USD"},
            create_date: "2022-05-05T16:49:04.541Z",
            destination: %Circlex.Struct.SourceDest{
              address: "0x2Eb953F992D4fa6E769FABf25D8218f21b793558",
              chain: "ETH",
              type: :blockchain
            },
            id: "83f18616-0f26-499a-aa8f-4fa4d563b974",
            source: %Circlex.Struct.SourceDest{id: "1000216185", type: :wallet},
            status: "complete",
            transaction_hash: "0xef6cf276368eb0e36162074b1c17a3256df14635c8603f076e826650c9f8a9ff"
          }
        ]
      }
  """
  def list_transfers(opts \\ []) do
    with {:ok, transfers} <- api_get("/v1/transfers", opts) do
      {:ok, Enum.map(transfers, &Transfer.deserialize/1)}
    end
  end

  @doc ~S"""
  Get a transfer.

  Reference: https://developers.circle.com/reference/payouts-transfers-get-id

  ## Examples

      iex> host = Circlex.Test.start_server()
      iex> Circlex.Api.Payouts.Transfers.get_transfer("588aa258-51c4-4a69-a3bc-88f007375364", host: host)
      {
        :ok,
        %Circlex.Struct.Transfer{
          amount: %Circlex.Struct.Amount{amount: "12345.00", currency: "USD"},
          create_date: "2022-07-15T23:51:42.729Z",
          destination: %Circlex.Struct.SourceDest{address: "0x871A9FF377eCf2632A0928950dCEb181557F2e17", chain: "ETH", type: :blockchain},
          id: "588aa258-51c4-4a69-a3bc-88f007375364",
          source: %Circlex.Struct.SourceDest{id: "1000788811", type: :wallet},
          status: "complete",
          transaction_hash: "0x69c8f26c43ec6028c785ab64083758857719806a444135d978c6e730f565ad18"
        }
      }
  """
  def get_transfer(id, opts \\ []) do
    with {:ok, transfer} <- api_get(Path.join("/v1/transfers", to_string(id)), opts) do
      {:ok, Transfer.deserialize(transfer)}
    end
  end
end
