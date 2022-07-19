defmodule Circlex.Emulator.Logic.PayoutLogicTest do
  use ExUnit.Case
  alias Circlex.Emulator.Logic.PayoutLogic
  alias Circlex.Struct.Payout
  doctest PayoutLogic

  @payout %Payout{
    adjustments: nil,
    amount: %{amount: "12111.00", currency: "USD"},
    create_date: "2022-07-15T20:03:32.718Z",
    destination: %{
      id: "4847be95-8b73-44cc-a329-549a25a776e2",
      name: "CAIXABANK, S.A. ****6789",
      type: "wire"
    },
    fees: %{amount: "25.00", currency: "USD"},
    id: "6e2e20bd-6ad6-4603-950b-64803647a4e6",
    return: nil,
    risk_evaluation: nil,
    source_wallet_id: "1000216185",
    status: "complete",
    tracking_ref: nil,
    update_date: "2022-07-15T20:20:32.255Z"
  }

  setup do
    payouts = [@payout]

    {:ok, %{payouts: payouts}}
  end

  test "get_payout/2", %{payouts: payouts} do
    assert {:ok, @payout} ==
             PayoutLogic.get_payout(
               payouts,
               @payout.id
             )
  end

  test "add_payout/2", %{payouts: payouts} do
    new_payout = %{@payout | id: "new"}

    assert {:ok, [new_payout, @payout]} ==
             PayoutLogic.add_payout(
               payouts,
               new_payout
             )
  end

  describe "update_payout/3" do
    test "setting payout", %{payouts: payouts} do
      updated_payout = %{@payout | status: "paid"}

      assert {:ok, [updated_payout]} ==
               PayoutLogic.update_payout(payouts, @payout.id, fn _ -> updated_payout end)
    end
  end
end
