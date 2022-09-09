defmodule Circlex.Struct.PayoutTest do
  use ExUnit.Case
  alias Circlex.Struct.{Amount, SourceDest, Payout}

  @payout %Payout{
    adjustments: "a",
    amount: %Amount{amount: "30.00", currency: "USD"},
    create_date: "2022-07-15T20:03:32.718Z",
    destination: %SourceDest{
      id: "4847be95-8b73-44cc-a329-549a25a776e2",
      type: :wire
    },
    fees: %Amount{amount: "25.00", currency: "USD"},
    id: "6e2e20bd-6ad6-4603-950b-64803647a4e6",
    return: "r",
    risk_evaluation: "re",
    source_wallet_id: "1000216185",
    status: "pending",
    tracking_ref: "tr",
    update_date: "2022-07-15T20:20:32.255Z"
  }

  @payout_with_external_ref %{@payout | external_ref: "ext_ref"}

  @payout_ser %{
    adjustments: "a",
    amount: %{amount: "30.00", currency: "USD"},
    createDate: "2022-07-15T20:03:32.718Z",
    destination: %{
      id: "4847be95-8b73-44cc-a329-549a25a776e2",
      type: "wire"
    },
    fees: %{amount: "25.00", currency: "USD"},
    id: "6e2e20bd-6ad6-4603-950b-64803647a4e6",
    return: "r",
    riskEvaluation: "re",
    sourceWalletId: "1000216185",
    status: "pending",
    trackingRef: "tr",
    updateDate: "2022-07-15T20:20:32.255Z"
  }

  @payout_ser_with_external_ref Map.put(@payout_ser, :externalRef, "ext_ref")

  describe "deserialize" do
    test "with external ref" do
      assert Payout.deserialize(@payout_ser_with_external_ref) == @payout_with_external_ref
    end

    test "without external ref" do
      assert Payout.deserialize(@payout_ser) == @payout
    end
  end

  describe "serialize" do
    test "normal" do
      assert Payout.serialize(@payout_with_external_ref) == @payout_ser_with_external_ref
    end

    test "normal without external_ref" do
      assert Payout.serialize(@payout) == Map.put(@payout_ser, :externalRef, nil)
    end

    test "for api" do
      assert Payout.serialize(@payout_with_external_ref, true) ==
               Map.drop(@payout_ser, [:riskEvaluation, :return, :adjustments])
    end
  end

  describe "JasonEncoding" do
    test "it calls serialize then jason.encode" do
      assert Jason.encode(@payout_with_external_ref) ==
               Jason.encode(@payout_ser_with_external_ref)
    end
  end
end
