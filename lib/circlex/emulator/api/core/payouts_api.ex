defmodule Circlex.Emulator.Api.Core.PayoutsApi do
  use Circlex.Emulator.Api

  @route path: "/", method: :post
  def create(%{destination: destination_params, amount: amount}) do
    # destination = Circlex.State.find_destination(destination_params)
    # with {:ok, payout} <- create_payout(destination, amount) do
    #   {:created, serialize(payout)}
    # end
    {:ok, %{}}
  end

  # def create_payout() do
  #   # Circlex.State.add_payout(%{id: Circlex.Util.id(), amount: amount})
  # end

  # def serialize(payout) do
  # end

end
