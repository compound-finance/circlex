defmodule Circlex.Api.Subscriptions do
  @moduledoc """
  API Client to the Subscriptions API.

  Reference: https://developers.circle.com/reference/listsubscriptions
  """

  import Circlex.Api.Tooling

  alias Circlex.Struct.Subscription

  @doc ~S"""
  Retrieve a list of existing notification subscriptions with details.

  Reference: https://developers.circle.com/reference/listsubscriptions

  ## Examples

      iex> host = Circlex.Test.start_server()
      iex> Circlex.Api.Subscriptions.list_subscriptions(host: host)
      {
        :ok,
        [
          %Circlex.Struct.Subscription{
            endpoint:
              "https://us-west1-treasury-stage.cloudfunctions.net/treasury-circle-sns-subscriber-function-443f885",
            id: "8e25e48a-8c84-4186-988c-4055bda7807a",
            subscription_details: [
              %{
                "status" => "confirmed",
                "url" =>
                  "arn:aws:sns:us-east-1:908968368384:sandbox_platform-notifications-topic:3c849cdd-af12-4c28-a4fe-d0d037079cc0"
              },
              %{
                "status" => "confirmed",
                "url" =>
                  "arn:aws:sns:us-west-2:908968368384:sandbox_platform-notifications-topic:48a51c19-6549-4b9c-be4a-926f77bb95a0"
              }
            ]
          }
        ]
      }
  """
  def list_subscriptions(opts \\ []) do
    with {:ok, subscriptions} <- api_get("/v1/notifications/subscriptions", opts) do
      {:ok, Enum.map(subscriptions, &Subscription.deserialize/1)}
    end
  end

  @doc ~S"""
  Subscribe to receiving notifications at a given endpoint.

  Reference: https://developers.circle.com/reference/subscribe

  ## Examples

      iex> host = Circlex.Test.start_server()
      iex> Circlex.Api.Subscriptions.subscribe("https://example.com", host: host)
      {:ok,
       %Circlex.Struct.Subscription{
         endpoint: "https://example.com",
         id: "a033a6d8-05ae-11ed-9e62-6a1733211c00",
         subscription_details: []
       }}
  """
  def subscribe(endpoint, opts \\ []) do
    idempotency_key = Keyword.get(opts, :idempotency_key, UUID.uuid1())

    with {:ok, subscription} <-
           api_post(
             "/v1/notifications/subscriptions",
             %{idempotencyKey: idempotency_key, endpoint: endpoint},
             opts
           ) do
      {:ok, Subscription.deserialize(subscription)}
    end
  end

  @doc ~S"""
  To remove a subscription, all its subscription requests' statuses must be
  either 'confirmed', 'deleted' or a combination of those.

  Reference: https://developers.circle.com/reference/unsubscribe

  ## Examples

      iex> host = Circlex.Test.start_server()
      iex> Circlex.Api.Subscriptions.unsubscribe("8e25e48a-8c84-4186-988c-4055bda7807a", host: host)
      {:ok, %{}}
  """
  def unsubscribe(id, opts \\ []) do
    idempotency_key = Keyword.get(opts, :idempotency_key, UUID.uuid1())

    case api_delete(
           Path.join("/v1/notifications/subscriptions", id),
           opts
         ) do
      {:ok, %{}} ->
        {:ok, %{}}
    end
  end
end
