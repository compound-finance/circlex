defmodule Circlex.Struct.Payout do
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

  alias Circlex.Emulator.State
  import Circlex.Struct.Util

  # Note: emulator-world only?
  # TODO: Get source wallet id better
  def new(source, destination, amount, metadata) do
    {:ok,
     %__MODULE__{
       id: State.next(:uuid),
       source_wallet_id: fetch(source, :id),
       destination: destination,
       amount: amount,
       fees: [],
       status: "pending",
       tracking_ref: State.next(:tracking_ref),
       create_date: State.next(:date),
       update_date: State.next(:date)
     }}
  end

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
