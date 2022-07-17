defmodule Circlex.Emulator.Api.Core.BankAccountsApi do
  @moduledoc """
  Mounted under `/v1/businessAccount/banks`.
  """
  use Circlex.Emulator.Api
  alias Circlex.Emulator.State.BankAccountState
  alias Circlex.Objects.BankAccount

  ### Wires

  # https://developers.circle.com/reference/getbusinessaccountwirebankaccounts
  @route "/wires"
  def list_bank_accounts(%{}) do
    {:ok, Enum.map(BankAccountState.all(), &BankAccount.serialize/1)}
  end

  # https://developers.circle.com/reference/payments-bank-accounts-wires-get-id
  @route "/wires/:bank_account_id"
  def get_bank_account(%{bank_account_id: bank_account_id}) do
    with {:ok, bank_account} <- BankAccountState.get(bank_account_id) do
      {:ok, BankAccount.serialize(bank_account)}
    end
  end

  # https://developers.circle.com/reference/payments-bank-accounts-wires-create
  @route path: "/wires", method: :post
  def create_bank_account(%{
        idempotencyKey: idempotency_key,
        accountNumber: account_number,
        routingNumber: routing_number,
        billingDetails: billing_details,
        bankAddress: bank_address
      }) do
    # TODO: Check idempotency key

    with {:ok, bank_account} <-
           BankAccount.new(account_number, routing_number, billing_details, bank_address) do
      BankAccountState.add_bank_account(bank_account)
      {:ok, BankAccount.serialize(bank_account)}
    end
  end
end
