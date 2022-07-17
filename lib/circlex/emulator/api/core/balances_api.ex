defmodule Circlex.Emulator.Api.Core.BalancesApi do
  @moduledoc """
  Mounted under `/v1/businessAccount/balances`.
  """
  use Circlex.Emulator.Api
  # alias Circlex.Emulator.State.WalletState
  # alias Circlex.Objects.Wallet

  # https://developers.circle.com/reference/getbusinessaccountbalances
  @route "/"
  def get_balances(%{}) do
    # TODO
    {:ok, %{available: [], unsettled: []}}
  end
end
