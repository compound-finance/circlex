defmodule Circlex.Emulator.State.SubscriptionState do
  require Logger

  import Circlex.Emulator.State.Util

  alias Circlex.Emulator.State
  alias Circlex.Struct.Subscription
  alias Circlex.Emulator.Logic.SubscriptionLogic

  def all_subscriptions(filters \\ []) do
    get_subscriptions_st(fn subscriptions -> subscriptions end, filters)
  end

  def get_subscription(id, filters \\ []) do
    get_subscriptions_st(
      fn subscriptions -> SubscriptionLogic.get_subscription(subscriptions, id) end,
      filters
    )
  end

  def add_subscription(subscription) do
    update_subscriptions_st(fn subscriptions ->
      SubscriptionLogic.add_subscription(subscriptions, subscription)
    end)
  end

  def update_subscription(subscription_id, f) do
    update_subscriptions_st(fn subscriptions ->
      SubscriptionLogic.update_subscription(subscriptions, subscription_id, f)
    end)
  end

  def remove_subscription(subscription_id) do
    update_subscriptions_st(fn subscriptions ->
      SubscriptionLogic.remove_subscription(subscriptions, subscription_id)
    end)
  end

  def deserialize(st) do
    %{st | subscriptions: Enum.map(st.subscriptions, &Subscription.deserialize/1)}
  end

  def serialize(st) do
    %{st | subscriptions: Enum.map(st.subscriptions, &Subscription.serialize/1)}
  end

  def initial_state() do
    %{subscriptions: []}
  end

  def new_subscription(endpoint) do
    {:ok,
     %Subscription{
       id: State.next(:uuid),
       endpoint: endpoint,
       subscription_details: []
     }}
  end

  defp get_subscriptions_st(mfa_or_fn, filters \\ []) do
    State.get_st(mfa_or_fn, [:subscriptions], &apply_filters(&1, filters))
  end

  defp update_subscriptions_st(mfa_or_fn, filters \\ []) do
    State.update_st(mfa_or_fn, [:subscriptions], &apply_filters(&1, filters))
  end
end
