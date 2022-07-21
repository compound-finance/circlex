defmodule Circlex.Struct.Transfer do
  import Circlex.Struct.Util

  defstruct [:id, :source, :destination, :amount, :transaction_hash, :status, :create_date]

  alias Circlex.Struct.{Amount, SourceDest}

  def deserialize(transfer) do
    %__MODULE__{
      id: fetch(transfer, :id),
      source: SourceDest.deserialize(fetch(transfer, :source)),
      destination: SourceDest.deserialize(fetch(transfer, :destination)),
      amount: Amount.deserialize(fetch(transfer, :amount)),
      transaction_hash: fetch(transfer, :transactionHash),
      status: fetch(transfer, :status),
      create_date: fetch(transfer, :createDate)
    }
  end

  def serialize(transfer) do
    %{
      id: transfer.id,
      source: SourceDest.serialize(transfer.source),
      destination: SourceDest.serialize(transfer.destination),
      amount: Amount.serialize(transfer.amount),
      transactionHash: transfer.transaction_hash,
      status: transfer.status,
      createDate: transfer.create_date
    }
  end
end
