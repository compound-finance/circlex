defmodule Circlex.Emulator.Logic.PayoutLogic do
  import Circlex.Emulator.Logic.LogicUtil

  require Logger

  alias Circlex.Struct.{Amount, Payout}
  alias Circlex.Emulator.Logic.WalletLogic

  def get_payout(payouts, payout_id) do
    find(payouts, fn %Payout{id: id} -> id == payout_id end)
  end

  def add_payout(payouts, payout) do
    {:ok, [payout | payouts]}
  end

  def update_payout(payouts, payout_id, f) do
    update(payouts, fn %Payout{id: id} -> id == payout_id end, f)
  end

  def process_payout(st = %{payouts: payouts, wallets: wallets}, payout_id) do
    {:ok, payout} = get_payout(payouts, payout_id)

    case payout.destination.type do
      :wire ->
        {:ok, wallet} = WalletLogic.get_wallet(wallets, payout.source_wallet_id)

        {:ok, wallets} =
          WalletLogic.update_balance(wallets, wallet.wallet_id, Amount.negate(payout.amount))

        {:ok, payouts} = update_payout(payouts, payout.id, fn p -> %{p | status: "paid"} end)

        Logger.warn("[NOTICE] Just paid out wire for #{Amount.display(payout.amount)}")

        {:ok,
         st
         |> Map.put(:wallets, wallets)
         |> Map.put(:payouts, payouts)}

      _ ->
        {:ok, st}
    end
  end
end
