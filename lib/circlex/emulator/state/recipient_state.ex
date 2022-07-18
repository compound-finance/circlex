defmodule Circlex.Emulator.State.RecipientState do
  alias Circlex.Emulator.State
  alias Circlex.Struct.Recipient

  # TODO: Add active/inactive?

  import State.Util

  def all() do
    State.get_in(:recipients)
  end

  def add_recipient(recipient) do
    State.update_in(:recipients, fn recipients -> [recipient | recipients] end)
  end

  def deserialize(st) do
    %{st | recipients: Enum.map(st.recipients, &Recipient.deserialize/1)}
  end

  def serialize(st) do
    %{st | recipients: Enum.map(st.recipients, &Recipient.serialize/1)}
  end

  def initial_state() do
    %{recipients: []}
  end

  def new_recipient(address, chain, currency, description) do
    {:ok,
     %Recipient{
       id: State.next(:uuid),
       address: address,
       chain: chain,
       currency: currency,
       description: description
     }}
  end
end
