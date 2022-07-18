defmodule Circlex.Emulator.Api.ManagementApi do
  @moduledoc """
  Mounted under `/v1/configuration`.
  """
  use Circlex.Emulator.Api

  alias Circlex.Emulator.State.WalletState

  # https://developers.circle.com/reference/getconfig
  @route "/"
  def get_config(%{}) do
    with {:ok, master_wallet} <- get_master_wallet() do
      {:ok,
       %{
         payments: %{
           masterWalletId: master_wallet.wallet_id
         }
       }}
    end
  end

  def get_master_wallet() do
    with {:ok, master_wallet} <- WalletState.master_wallet() do
      {:ok, master_wallet}
    else
      :not_found ->
        {:error, "System Configuration Issue: no main \"merchant\" wallet specified"}
    end
  end
end
