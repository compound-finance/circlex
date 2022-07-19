defmodule Circlex.Struct.Amount do
  defstruct [:amount, :currency]

  import Circlex.Struct.Util

  def deserialize(amount) do
    %__MODULE__{
      amount: fetch(amount, :amount),
      currency: fetch(amount, :currency)
    }
  end

  def serialize(amount) do
    %{
      amount: amount.amount,
      currency: amount.currency
    }
  end
end
