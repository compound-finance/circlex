defmodule Circlex.Struct.Payment do
  import Circlex.Struct.Util

  alias Circlex.Struct.{Amount, SourceDest}

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
      amount: Amount.deserialize(fetch(payment, :amount)),
      fees: Amount.deserialize(fetch(payment, :fees)),
      create_date: fetch(payment, :createDate),
      update_date: fetch(payment, :updateDate),
      merchant_id: fetch(payment, :merchantId),
      merchant_wallet_id: fetch(payment, :merchantWalletId),
      source: SourceDest.deserialize(fetch(payment, :source)),
      refunds: fetch(payment, :refunds)
    }
  end

  def serialize(payment = %__MODULE__{}) do
    %{
      id: payment.id,
      type: payment.type,
      status: payment.status,
      description: payment.description,
      amount: Amount.serialize(payment.amount),
      fees: Amount.serialize(payment.fees),
      createDate: payment.create_date,
      updateDate: payment.update_date,
      merchantId: payment.merchant_id,
      merchantWalletId: payment.merchant_wallet_id,
      source: SourceDest.serialize(payment.source),
      refunds: payment.refunds
    }
  end
end
