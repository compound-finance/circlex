defmodule Circlex.Emulator.Logic.SubscriptionLogicTest do
  use ExUnit.Case
  alias Circlex.Emulator.Logic.SubscriptionLogic
  alias Circlex.Struct.Subscription
  doctest SubscriptionLogic

  @subscription %Circlex.Struct.Subscription{
    endpoint:
      "https://us-west1-treasury-stage.cloudfunctions.net/treasury-circle-sns-subscriber-function-443f885",
    id: "8e25e48a-8c84-4186-988c-4055bda7807a",
    subscription_details: [
      %{
        status: "confirmed",
        url:
          "arn:aws:sns:us-east-1:908968368384:sandbox_platform-notifications-topic:3c849cdd-af12-4c28-a4fe-d0d037079cc0"
      },
      %{
        status: "confirmed",
        url:
          "arn:aws:sns:us-west-2:908968368384:sandbox_platform-notifications-topic:48a51c19-6549-4b9c-be4a-926f77bb95a0"
      }
    ]
  }

  setup do
    subscriptions = [@subscription]

    {:ok, %{subscriptions: subscriptions}}
  end

  test "get_subscription/2", %{subscriptions: subscriptions} do
    assert {:ok, @subscription} ==
             SubscriptionLogic.get_subscription(
               subscriptions,
               @subscription.id
             )
  end

  test "add_subscription/2", %{subscriptions: subscriptions} do
    new_subscription = %{@subscription | id: "new"}

    assert {:ok, [new_subscription, @subscription]} ==
             SubscriptionLogic.add_subscription(
               subscriptions,
               new_subscription
             )
  end

  describe "update_subscription/3" do
    test "setting subscription", %{subscriptions: subscriptions} do
      updated_subscription = %{@subscription | endpoint: "cool"}

      assert {:ok, [updated_subscription]} ==
               SubscriptionLogic.update_subscription(subscriptions, @subscription.id, fn _ ->
                 updated_subscription
               end)
    end
  end
end
