defmodule Circlex.Emulator.State.RecipientState do
  alias Circlex.Emulator.State
  alias Circlex.Struct.Recipient
  alias Circlex.Emulator.Logic.RecipientLogic

  import State.Util

  # TODO: Add active/inactive?

  def all_recipients(filters \\ []) do
    get_recipients_st(fn recipients -> recipients end, filters)
  end

  def get_recipient(id, filters \\ []) do
    get_recipients_st(fn recipients -> RecipientLogic.get_recipient(recipients, id) end, filters)
  end

  def add_recipient(recipient) do
    update_recipients_st(fn recipients -> RecipientLogic.add_recipient(recipients, recipient) end)
  end

  def update_recipient(recipient_id, f) do
    update_recipients_st(fn recipients ->
      RecipientLogic.update_recipient(recipients, recipient_id, f)
    end)
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

  defp get_recipients_st(mfa_or_fn, filters) do
    State.get_st(mfa_or_fn, [:recipients], &apply_filters(&1, filters))
  end

  defp update_recipients_st(mfa_or_fn, filters \\ []) do
    State.update_st(mfa_or_fn, [:recipients], &apply_filters(&1, filters))
  end
end
