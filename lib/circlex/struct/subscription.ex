defmodule Circlex.Struct.Subscription do
  defstruct [:id, :endpoint, :subscription_details]

  alias Circlex.Emulator.State
  import Circlex.Struct.Util

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
