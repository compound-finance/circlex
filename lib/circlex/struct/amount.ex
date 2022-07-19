defmodule Circlex.Struct.Amount do
  import Circlex.Struct.Util

  defstruct [:amount, :currency]

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

  def negate(amount = %__MODULE__{}) do
    %{amount | amount: negate(amount.amount)}
  end

  def negate(amount) when is_binary(amount) do
    amount
    |> decode_amount()
    |> Kernel.*(-1)
    |> encode_amount()
  end

  def from_wei(amount, decimals) do
    divisor = :math.pow(10, decimals)

    %__MODULE__{
      amount: encode_amount(amount / divisor),
      currency: "USD"
    }
  end

  def to_wei(%__MODULE__{amount: amount}, decimals) do
    floor(decode_amount(amount) * :math.pow(10, decimals))
  end

  def encode_amount(amount), do: :erlang.float_to_binary(amount, decimals: 2)
  def decode_amount(amount), do: :erlang.binary_to_float(amount)
end
