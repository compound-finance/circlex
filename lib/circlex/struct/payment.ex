defmodule Circlex.Struct.Payment do
  import Circlex.Struct.Util

  defstruct [
    :id,
    :type,
    :status,
    :description,
    :amount,
    :fees,
    :create_date,
    :update_date,
    :merchant_id,
    :merchant_wallet_id,
    :source,
    :refunds
  ]

  def deserialize(payment) do
    %__MODULE__{
      id: fetch(payment, :id),
      type: fetch(payment, :type),
      status: fetch(payment, :status),
      description: fetch(payment, :description),
      amount: fetch(payment, :amount),
      fees: fetch(payment, :fees),
      create_date: fetch(payment, :createDate),
      update_date: fetch(payment, :updateDate),
      merchant_id: fetch(payment, :merchantId),
      merchant_wallet_id: fetch(payment, :merchantWalletId),
      source: fetch(payment, :source),
      refunds: fetch(payment, :refunds)
    }
  end

  def serialize(payment) do
    %{
      id: fetch(payment, :id),
      type: fetch(payment, :type),
      status: fetch(payment, :status),
      description: fetch(payment, :description),
      amount: fetch(payment, :amount),
      fees: fetch(payment, :fees),
      createDate: fetch(payment, :create_date),
      updateDate: fetch(payment, :update_date),
      merchantId: fetch(payment, :merchant_id),
      merchantWalletId: fetch(payment, :merchant_wallet_id),
      source: fetch(payment, :source),
      refunds: fetch(payment, :refunds)
    }
  end
end
