defmodule Circlex.Struct.Transfer do
  import Circlex.Struct.Util

  defstruct [:id, :source, :destination, :amount, :transaction_hash, :status, :create_date]

  def deserialize(transfer) do
    %__MODULE__{
      id: fetch(transfer, :id),
      source: fetch(transfer, :source),
      destination: fetch(transfer, :destination),
      amount: fetch(transfer, :amount),
      transaction_hash: fetch(transfer, :transactionHash),
      status: fetch(transfer, :status),
      create_date: fetch(transfer, :createDate)
    }
  end

  def serialize(transfer) do
    %{
      id: transfer.id,
      source: transfer.source,
      destination: transfer.destination,
      amount: transfer.amount,
      transactionHash: transfer.transaction_hash,
      status: transfer.status,
      createDate: transfer.create_date
    }
  end
end
