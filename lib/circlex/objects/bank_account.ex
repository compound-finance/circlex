defmodule Circlex.Objects.BankAccount do
  defstruct [
    :id,
    :status,
    :description,
    :tracking_ref,
    :fingerprint,
    :billing_details,
    :bank_address,
    :create_date,
    :update_date
  ]

  alias Circlex.Emulator.State
  import Circlex.Objects.Util

  # Note: emulator-world only?
  def new(account_number, routing_number, billing_details, bank_address) do
    {:ok,
     %__MODULE__{
       id: State.next(:uuid),
       status: "pending",
       description: "#{fetch(bank_address, :bankName)} #{String.slice(account_number, -4..-1)}",
       tracking_ref: State.next(:tracking_ref),
       fingerprint: State.next(:uuid),
       billing_details: billing_details,
       bank_address: bank_address,
       create_date: State.next(:date),
       update_date: State.next(:date)
     }}
  end

  def deserialize(bank_account) do
    %__MODULE__{
      id: fetch(bank_account, :id),
      status: fetch(bank_account, :status),
      description: fetch(bank_account, :description),
      tracking_ref: fetch(bank_account, :trackingRef),
      fingerprint: fetch(bank_account, :fingerprint),
      billing_details: fetch(bank_account, :billingDetails),
      bank_address: fetch(bank_account, :bankAddress),
      create_date: fetch(bank_account, :createDate),
      update_date: fetch(bank_account, :updateDate)
    }
  end

  def serialize(bank_account) do
    %{
      id: bank_account.id,
      status: bank_account.status,
      description: bank_account.description,
      trackingRef: bank_account.tracking_ref,
      fingerprint: bank_account.fingerprint,
      billingDetails: bank_account.billing_details,
      bankAddress: bank_account.bank_address,
      createDate: bank_account.create_date,
      updateDate: bank_account.update_date
    }
  end
end
