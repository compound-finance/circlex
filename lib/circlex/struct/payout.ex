defmodule Circlex.Struct.Payout do
  import Circlex.Struct.Util

  alias Circlex.Struct.{Amount, SourceDest}

  defstruct [
    :id,
    :source_wallet_id,
    :destination,
    :amount,
    :fees,
    :status,
    :tracking_ref,
    :risk_evaluation,
    :adjustments,
    :return,
    :create_date,
    :update_date
  ]

  def deserialize(payout) do
    %__MODULE__{
      id: fetch(payout, :id),
      source_wallet_id: fetch(payout, :sourceWalletId),
      destination: SourceDest.deserialize(fetch(payout, :destination)),
      amount: Amount.deserialize(fetch(payout, :amount)),
      fees: Amount.deserialize(fetch(payout, :fees)),
      status: fetch(payout, :status),
      tracking_ref: fetch(payout, :trackingRef),
      create_date: fetch(payout, :createDate),
      update_date: fetch(payout, :updateDate)
    }
  end

  def serialize(payout) do
    %{
      id: payout.id,
      sourceWalletId: payout.source_wallet_id,
      destination: SourceDest.serialize(payout.destination),
      amount: Amount.serialize(payout.amount),
      fees: Amount.serialize(payout.fees),
      status: payout.status,
      trackingRef: payout.tracking_ref,
      createDate: payout.create_date,
      updateDate: payout.update_date
    }
  end
end
