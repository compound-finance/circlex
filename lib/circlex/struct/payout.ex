defmodule Circlex.Struct.Payout do
  import Circlex.Struct.Util

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
      destination: fetch(payout, :destination),
      amount: fetch(payout, :amount),
      fees: fetch(payout, :fees),
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
      destination: payout.destination,
      amount: payout.amount,
      fees: payout.fees,
      status: payout.status,
      trackingRef: payout.tracking_ref,
      createDate: payout.create_date,
      updateDate: payout.update_date
    }
  end
end
