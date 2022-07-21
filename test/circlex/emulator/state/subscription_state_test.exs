defmodule Circlex.Emulator.State.SubscriptionStateTest do
  use ExUnit.Case
  alias Circlex.Emulator.State.SubscriptionState
  alias Circlex.Emulator.State
  alias Circlex.Struct.Subscription
  doctest SubscriptionState

  @subscription %Subscription{
    endpoint:
      "https://us-west1-treasury-stage.cloudfunctions.net/treasury-circle-sns-subscriber-function-443f885",
    id: "8e25e48a-8c84-4186-988c-4055bda7807a",
    subscription_details: [
      %{
        status: "confirmed",
        url: "arn:aws:sns:us-east-1:908968368384:sandbox_platform-notifications-topic:3c849cdd-af12-4c28-a4fe-d0d037079cc0"
      },
      %{
        status: "confirmed",
        url: "arn:aws:sns:us-west-2:908968368384:sandbox_platform-notifications-topic:48a51c19-6549-4b9c-be4a-926f77bb95a0"
      }
    ]
  }

  setup do
    {:ok, state_pid} = State.start_link(Circlex.Test.get_opts())
    Process.put(:state_pid, state_pid)

    :ok
  end

  test "all_subscriptions/0" do
    assert Enum.member?(SubscriptionState.all_subscriptions(), @subscription)
  end

  describe "get_subscription/1" do
    test "found" do
      assert {:ok, @subscription} ==
               SubscriptionState.get_subscription(@subscription.id)
    end

    test "not found" do
      assert :not_found == SubscriptionState.get_subscription("55")
    end
  end

  test "add_subscription/1" do
    SubscriptionState.all_subscriptions()
    new_subscription = %{@subscription | id: @subscription.id}
    SubscriptionState.add_subscription(new_subscription)
    assert [^new_subscription | _] = SubscriptionState.all_subscriptions()
  end

  test "update_subscription/1" do
    SubscriptionState.update_subscription(@subscription.id, fn subscription ->
      %{subscription | endpoint: "https://example.com/cool"}
    end)

    assert {:ok, %{@subscription | endpoint: "https://example.com/cool"}} ==
             SubscriptionState.get_subscription(@subscription.id)
  end
end
