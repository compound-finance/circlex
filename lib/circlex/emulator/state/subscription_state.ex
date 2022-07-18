defmodule Circlex.Emulator.State.SubscriptionState do
  alias Circlex.Emulator.State
  alias Circlex.Struct.Subscription

  import State.Util

  def all() do
    State.get_in(:subscriptions)
  end

  def get(id) do
    all()
    |> find!(fn %Subscription{id: subscription_id} -> id == subscription_id end)
  end

  def add_subscription(subscription) do
    State.update_in(:subscriptions, fn subscriptions -> [subscription | subscriptions] end)
  end

  def remove_subscription(subscription_id) do
    State.update_in(:subscriptions, fn subscriptions ->
      Enum.filter(subscriptions, fn subscription -> subscription.id != subscription_id end)
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
end
