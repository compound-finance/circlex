defmodule Circlex.Emulator.Logic.BankAccountLogic do
  import Circlex.Emulator.Logic.LogicUtil

  alias Circlex.Struct.BankAccount

  def get_bank_account(bank_accounts, bank_account_id) do
    find(bank_accounts, fn %BankAccount{id: id} -> id == bank_account_id end)
  end

  def add_bank_account(bank_accounts, bank_account) do
    {:ok, [bank_account | bank_accounts]}
  end

  def update_bank_account(bank_accounts, bank_account_id, f) do
    update(bank_accounts, fn %BankAccount{id: id} -> id == bank_account_id end, f)
  end
end
