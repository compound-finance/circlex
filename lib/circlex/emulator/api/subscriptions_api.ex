defmodule Circlex.Emulator.Api.SubscriptionsApi do
  @moduledoc """
  Mounted under `/v1/notifications/subscriptions`.
  """
  use Circlex.Emulator.Api
  alias Circlex.Emulator.State.SubscriptionState
  alias Circlex.Struct.Subscription

  # https://developers.circle.com/reference/listsubscriptions
  @route "/"
  def list_subscriptions(%{}) do
    {:ok, Enum.map(SubscriptionState.all_subscriptions(), &Subscription.serialize/1)}
  end

  # https://developers.circle.com/reference/subscribe
  @route path: "/", method: :post
  def create_subscription(%{idempotencyKey: idempotency_key, endpoint: endpoint}) do
    with :ok <- check_idempotency_key(idempotency_key),
         {:ok, subscription} <- SubscriptionState.new_subscription(endpoint) do
      SubscriptionState.add_subscription(subscription)
      {:ok, Subscription.serialize(subscription)}
    end
  end

  # https://developers.circle.com/reference/unsubscribe
  @route path: "/:subscription_id", method: :delete
  def remove_subscription(%{subscription_id: subscription_id}) do
    with {:ok, subscription} <- SubscriptionState.get_subscription(subscription_id) do
      SubscriptionState.remove_subscription(subscription.id)
      {:ok, %{}}
    end
  end
end
