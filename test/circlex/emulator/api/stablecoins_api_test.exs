defmodule Circlex.Emulator.Api.StablecoinsApiTest do
  use Circlex.ApiCase
  doctest Circlex.Emulator.Api.StablecoinsApi

  alias Circlex.Emulator.Api.StablecoinsApi

  test "gets stablecoin data" do
    assert {
             :ok,
             [
               %{
                 chains: [
                   %{
                     amount: "1050479.52",
                     chain: "ETH",
                     updateDate: "2022-07-18T01:29:29.950788Z"
                   }
                 ],
                 name: "Euro Coin",
                 symbol: "EUROC",
                 totalAmount: "1050479.52"
               },
               %{
                 chains: [
                   %{
                     amount: "252665756155.330491",
                     chain: "ALGO",
                     updateDate: "2022-07-18T01:29:30.526357Z"
                   },
                   %{
                     amount: "6323082119.02",
                     chain: "AVAX",
                     updateDate: "2022-07-18T01:29:30.560738Z"
                   },
                   %{
                     amount: "309009160808.08",
                     chain: "ETH",
                     updateDate: "2022-07-18T01:29:30.285124Z"
                   },
                   %{
                     amount: "2768511837.06",
                     chain: "FLOW",
                     updateDate: "2022-07-18T01:29:30.461867Z"
                   },
                   %{
                     amount: "5522363273.65",
                     chain: "HBAR",
                     updateDate: "2022-06-22T14:40:57.074283Z"
                   },
                   %{
                     amount: "22068229341.84",
                     chain: "SOL",
                     updateDate: "2022-07-18T01:29:30.159087Z"
                   },
                   %{
                     amount: "1117948763.83",
                     chain: "TRX",
                     updateDate: "2022-07-18T01:29:30.202047Z"
                   },
                   %{
                     amount: "3524683080.1912893",
                     chain: "XLM",
                     updateDate: "2022-07-18T01:29:30.244743Z"
                   }
                 ],
                 name: "USD Coin",
                 symbol: "USDC",
                 totalAmount: "602999735379.0017803"
               }
             ]
           } == StablecoinsApi.get_stablecoins(%{})
  end
end
