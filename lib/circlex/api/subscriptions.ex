defmodule Circlex.Api.Subscriptions do
  @moduledoc """
  Core API...
  """
  import Circlex.Api

  @doc ~S"""
  Retrieve a list of existing notification subscriptions with details.

  Reference: https://developers.circle.com/reference/listsubscriptions

  ## Examples

      iex> host = Circlex.Test.start_server()
      iex> Circlex.Api.Subscriptions.list_subscriptions(host: host)
      {:error, %{error: "Not implemented by Circlex client"}}
  """
  def list_subscriptions(opts \\ []) do
    not_implemented()
  end

  @doc ~S"""
  Subscribe to receiving notifications at a given endpoint.

  Reference: https://developers.circle.com/reference/subscribe

  ## Examples

      iex> host = Circlex.Test.start_server()
      iex> Circlex.Api.Subscriptions.subscribe(host: host)
      {:error, %{error: "Not implemented by Circlex client"}}
  """
  def subscribe(opts \\ []) do
    not_implemented()
  end

  @doc ~S"""
  To remove a subscription, all its subscription requests' statuses must be
  either 'confirmed', 'deleted' or a combination of those.

  Reference: https://developers.circle.com/reference/unsubscribe

  ## Examples

      iex> host = Circlex.Test.start_server()
      iex> Circlex.Api.Subscriptions.unsubscribe(host: host)
      {:error, %{error: "Not implemented by Circlex client"}}
  """
  def unsubscribe(opts \\ []) do
    not_implemented()
  end
end
