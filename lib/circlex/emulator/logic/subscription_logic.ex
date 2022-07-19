defmodule Circlex.Emulator.Logic.SubscriptionLogic do
  import Circlex.Emulator.Logic.LogicUtil

  alias Circlex.Struct.Subscription

  def get_subscription(subscriptions, subscription_id) do
    find(subscriptions, fn %Subscription{id: id} -> id == subscription_id end)
  end

  def add_subscription(subscriptions, subscription) do
    {:ok, [subscription | subscriptions]}
  end

  def update_subscription(subscriptions, subscription_id, f) do
    update(subscriptions, fn %Subscription{id: id} -> id == subscription_id end, f)
  end

  def remove_subscription(subscriptions, subscription_id) do
    update(subscriptions, fn %Subscription{id: id} -> id == subscription_id end, fn _ ->
      nil
    end)
  end
end
