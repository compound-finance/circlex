defmodule Circlex.Api.Core.Transfers do
  @moduledoc """
  API Client to the Core Transfers API.

  Reference: https://developers.circle.com/reference/createbusinessaccounttransfer
  """

  import Circlex.Api.Tooling

  alias Circlex.Struct.Transfer

  @doc ~S"""
  A transfer can be made from an existing business account to a blockchain location.

  Reference: https://developers.circle.com/reference/createbusinessaccounttransfer

  ## Examples

      iex> host = Circlex.Test.start_server()
      iex> destination = %{address: "0x871A9FF377eCf2632A0928950dCEb181557F2e17", chain: "ETH", type: "blockchain"}
      iex> amount = %{amount: "12345.00", currency: "USD"}
      iex> Circlex.Api.Core.Transfers.create(destination, amount, host: host)
      {
        :ok,
         %Circlex.Struct.Transfer{
          amount: %Circlex.Struct.Amount{amount: "12345.00", currency: "USD"},
          create_date: nil,
          destination: %Circlex.Struct.SourceDest{address: "0x871A9FF377eCf2632A0928950dCEb181557F2e17", chain: "ETH", type: :blockchain},
          id: "a033a6d8-05ae-11ed-9e62-6a1733211c00",
          source: %Circlex.Struct.SourceDest{id: "1000216185", type: :wallet},
          status: nil,
          transaction_hash: nil
        }
      }
  """
  def create(destination, amount, opts \\ []) do
    idempotency_key = Keyword.get(opts, :idempotency_key, UUID.uuid1())

    case api_post(
           "/v1/businessAccount/transfers",
           %{
             idempotencyKey: idempotency_key,
             destination: destination,
             amount: amount
           },
           opts
         ) do
      {:ok,
       %{
         "id" => id,
         "source" => source,
         "destination" => destination,
         "amount" => amount,
         "transactionHash" => transaction_hash,
         "status" => status,
         "createDate" => create_date
       }} ->
        {:ok,
         %Transfer{
           id: id,
           source: source,
           destination: destination,
           amount: amount,
           transaction_hash: transaction_hash,
           status: status,
           create_date: create_date
         }}
    end
  end

  @doc ~S"""
  Searches for transfers from your business account.

  Reference: https://developers.circle.com/reference/searchbusinessaccounttransfers

  # TODO: Filters

  ## Examples

      iex> host = Circlex.Test.start_server()
      iex> Circlex.Api.Core.Transfers.list_transfers(host: host)
      {
        :ok,
        [
          %Circlex.Struct.Transfer{
            amount: %Circlex.Struct.Amount{amount: "8999998.14", currency: "USD"},
            create_date: "2022-05-05T16:49:04.541Z",
            destination: %Circlex.Struct.SourceDest{address: "0x2eb953f992d4fa6e769fabf25d8218f21b793558", chain: "ETH", type: :blockchain},
            id: "83f18616-0f26-499a-aa8f-4fa4d563b974",
            source: %Circlex.Struct.SourceDest{id: "1000216185", type: :wallet},
            status: "complete",
            transaction_hash: "0xef6cf276368eb0e36162074b1c17a3256df14635c8603f076e826650c9f8a9ff"
          }
        ]
      }
  """
  def list_transfers(opts \\ []) do
    with {:ok, transfers} <- api_get("/v1/businessAccount/transfers", opts) do
      {:ok, Enum.map(transfers, &Transfer.deserialize/1)}
    end
  end

  @doc ~S"""
  Get a transfer.

  Reference: https://developers.circle.com/reference/getbusinessaccounttransfer

  ## Examples

      iex> host = Circlex.Test.start_server()
      iex> Circlex.Api.Core.Transfers.get_transfer("83f18616-0f26-499a-aa8f-4fa4d563b974", host: host)
      {
        :ok,
        %Circlex.Struct.Transfer{
          amount: %Circlex.Struct.Amount{amount: "8999998.14", currency: "USD"},
          create_date: "2022-05-05T16:49:04.541Z",
          destination: %Circlex.Struct.SourceDest{address: "0x2eb953f992d4fa6e769fabf25d8218f21b793558", chain: "ETH", type: :blockchain},
          id: "83f18616-0f26-499a-aa8f-4fa4d563b974",
          source: %Circlex.Struct.SourceDest{id: "1000216185", type: :wallet},
          status: "complete",
          transaction_hash: "0xef6cf276368eb0e36162074b1c17a3256df14635c8603f076e826650c9f8a9ff"
        }
      }
  """
  def get_transfer(id, opts \\ []) do
    with {:ok, transfer} <- api_get(Path.join("/v1/businessAccount/transfers", to_string(id)), opts) do
      {:ok, Transfer.deserialize(transfer)}
    end
  end
end
