defmodule Circlex.Emulator.Api.SubscriptionsApiTest do
  use Circlex.ApiCase
  alias Circlex.Emulator.Api.SubscriptionsApi
  doctest SubscriptionsApi

  test "create_subscription/1" do
    assert {:ok,
            %{
              id: "a033a6d8-05ae-11ed-9e62-6a1733211c00",
              endpoint: "http://example.com",
              subscriptionDetails: []
            }} ==
             SubscriptionsApi.create_subscription(%{
               idempotencyKey: UUID.uuid1(),
               endpoint: "http://example.com"
             })
  end

  test "list_subscriptions/1" do
    assert {:ok,
            [
              %{
                endpoint:
                  "https://us-west1-treasury-stage.cloudfunctions.net/treasury-circle-sns-subscriber-function-443f885",
                id: "8e25e48a-8c84-4186-988c-4055bda7807a",
                subscriptionDetails: [
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
            ]} == SubscriptionsApi.list_subscriptions(%{})
  end

  test "remove_subscription/1" do
    assert {:ok, %{}} ==
             SubscriptionsApi.remove_subscription(%{
               subscription_id: "8e25e48a-8c84-4186-988c-4055bda7807a"
             })

    assert {:ok, []} == SubscriptionsApi.list_subscriptions(%{})
  end
end
