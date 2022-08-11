defmodule Circlex.Emulator.Api.Core.BankAccountsApi do
  @moduledoc """
  Mounted under `/v1/businessAccount/banks` and `/v1/banks`
  """
  use Circlex.Emulator.Api
  alias Circlex.Emulator.State.BankAccountState
  alias Circlex.Struct.BankAccount
  alias Circlex.Struct.WireInstructions

  ### Wires

  # https://developers.circle.com/reference/getbusinessaccountwirebankaccounts
  @route "/wires"
  def list_bank_accounts(%{}) do
    {:ok, Enum.map(BankAccountState.all_bank_accounts(), &BankAccount.serialize/1)}
  end

  # https://developers.circle.com/reference/payments-bank-accounts-wires-get-id
  @route "/wires/:bank_account_id"
  def get_bank_account(%{bank_account_id: bank_account_id}) do
    with {:ok, bank_account} <- BankAccountState.get_bank_account(bank_account_id) do
      {:ok, BankAccount.serialize(bank_account)}
    end
  end

  # https://developers.circle.com/reference/payments-bank-accounts-wires-get-id-instructions
  @route "/wires/:bank_account_id/instructions"
  def get_wire_instructions(%{bank_account_id: bank_account_id}) do
    with {:ok, bank_account_sending_wire} <- BankAccountState.get_bank_account(bank_account_id) do
      {:ok, WireInstructions.serialize(bank_account_sending_wire)}
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
    with :ok <- check_idempotency_key(idempotency_key),
         {:ok, bank_account} <-
           BankAccountState.new_bank_account(
             account_number,
             routing_number,
             billing_details,
             bank_address
           ) do
      BankAccountState.add_bank_account(bank_account)
      {:ok, BankAccount.serialize(bank_account)}
    end
  end
end
