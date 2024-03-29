defmodule Circlex.Struct.Subscription do
  use Circlex.Struct.JasonHelper
  import Circlex.Struct.Util

  defstruct [:id, :endpoint, :subscription_details]

  def deserialize(subscription) do
    %__MODULE__{
      id: fetch(subscription, :id),
      endpoint: fetch(subscription, :endpoint),
      subscription_details: fetch(subscription, :subscriptionDetails)
    }
  end

  def serialize(subscription) do
    %{
      id: fetch(subscription, :id),
      endpoint: fetch(subscription, :endpoint),
      subscriptionDetails: fetch(subscription, :subscription_details)
    }
  end
end
