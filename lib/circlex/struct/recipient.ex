defmodule Circlex.Struct.Recipient do
  use Circlex.Struct.JasonHelper
  import Circlex.Struct.Util

  defstruct [:id, :address, :chain, :currency, :description]

  def deserialize(recipient) do
    %__MODULE__{
      id: fetch(recipient, :id),
      address: fetch(recipient, :address),
      chain: fetch(recipient, :chain),
      currency: fetch(recipient, :currency),
      description: fetch(recipient, :description)
    }
  end

  def serialize(recipient) do
    %{
      id: recipient.id,
      address: String.downcase(recipient.address),
      chain: recipient.chain,
      currency: recipient.currency,
      description: recipient.description
    }
  end
end
