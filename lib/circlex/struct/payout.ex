defmodule Circlex.Struct.Payout do
  use Circlex.Struct.JasonHelper
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
    :update_date,
    :external_ref
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
      risk_evaluation: fetch(payout, :riskEvaluation),
      adjustments: fetch(payout, :adjustments),
      return: fetch(payout, :return),
      create_date: fetch(payout, :createDate),
      update_date: fetch(payout, :updateDate),
      external_ref: fetch(payout, :externalRef)
    }
  end

  def serialize(payout, for_api \\ false) do
    Map.merge(
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
      },
      if(for_api,
        do: %{},
        else: %{
          externalRef: payout.external_ref,
          riskEvaluation: payout.risk_evaluation,
          adjustments: payout.adjustments,
          return: payout.return
        }
      )
    )
  end
end
