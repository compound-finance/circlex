defmodule Circlex.Api.Stablecoins do
  @moduledoc """
  Core API...
  """
  import Circlex.Api

  @doc ~S"""
  Retrieves total circulating supply for supported stablecoins across all chains.

  Reference: https://developers.circle.com/reference/getstablecoins

  ## Examples

      iex> host = Circlex.Test.start_server()
      iex> Circlex.Api.Stablecoins.get_stablecoins(host: host)
      {
        :ok,
        [
          %{
            chains: [
              %{amount: "1050479.52", chain: "ETH", update_date: "2022-07-18T01:29:29.950788Z"}
            ],
            name: "Euro Coin",
            symbol: "EUROC",
            total_amount: "1050479.52"
          },
          %{
            chains: [
              %{
                amount: "252665756155.330491",
                chain: "ALGO",
                update_date: "2022-07-18T01:29:30.526357Z"
              },
              %{
                amount: "6323082119.02",
                chain: "AVAX",
                update_date: "2022-07-18T01:29:30.560738Z"
              },
              %{
                amount: "309009160808.08",
                chain: "ETH",
                update_date: "2022-07-18T01:29:30.285124Z"
              },
              %{
                amount: "2768511837.06",
                chain: "FLOW",
                update_date: "2022-07-18T01:29:30.461867Z"
              },
              %{
                amount: "5522363273.65",
                chain: "HBAR",
                update_date: "2022-06-22T14:40:57.074283Z"
              },
              %{
                amount: "22068229341.84",
                chain: "SOL",
                update_date: "2022-07-18T01:29:30.159087Z"
              },
              %{
                amount: "1117948763.83",
                chain: "TRX",
                update_date: "2022-07-18T01:29:30.202047Z"
              },
              %{
                amount: "3524683080.1912893",
                chain: "XLM",
                update_date: "2022-07-18T01:29:30.244743Z"
              }
            ],
            name: "USD Coin",
            symbol: "USDC",
            total_amount: "602999735379.0017803"
          }
        ]
      }
  """
  def get_stablecoins(opts \\ []) do
    with {:ok, stablecoins} <-
           api_get("/v1/stablecoins", opts) do
      {:ok,
       Enum.map(stablecoins, fn %{
                                  "name" => name,
                                  "symbol" => symbol,
                                  "chains" => chains,
                                  "totalAmount" => total_amount
                                } ->
         %{
           name: name,
           symbol: symbol,
           chains:
             Enum.map(chains, fn %{
                                   "amount" => amount,
                                   "chain" => chain,
                                   "updateDate" => update_date
                                 } ->
               %{
                 amount: amount,
                 chain: chain,
                 update_date: update_date
               }
             end),
           total_amount: total_amount
         }
       end)}
    end
  end
end
