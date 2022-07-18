defmodule Circlex.Emulator.State.PaymentState do
  alias Circlex.Emulator.State
  alias Circlex.Struct.Payment

  import State.Util

  def all(filters \\ []) do
    State.get_in(:payments)
    |> apply_filters(filters)
  end

  def get(id, filters \\ []) do
    all(filters)
    |> find!(fn %Payment{id: payment_id} ->
      to_string(id) == to_string(payment_id)
    end)
  end

  def add_payment(payment) do
    State.update_in(:payments, fn payments -> [payment | payments] end)
  end

  def deserialize(st) do
    %{st | payments: Enum.map(st.payments, &Payment.deserialize/1)}
  end

  def serialize(st) do
    %{st | payments: Enum.map(st.payments, &Payment.serialize/1)}
  end

  def initial_state() do
    %{payments: []}
  end
end
