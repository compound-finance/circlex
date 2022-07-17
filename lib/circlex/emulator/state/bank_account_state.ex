defmodule Circlex.Emulator.State.BankAccountState do
  alias Circlex.Emulator.State
  alias Circlex.Objects.BankAccount

  import State.Util

  def all() do
    State.get_in(:bank_accounts)
  end

  def get(id) do
    all()
    |> find!(fn %BankAccount{id: bank_account_id} ->
      to_string(id) == to_string(bank_account_id)
    end)
  end

  def add_bank_account(bank_account) do
    State.update_in(:bank_accounts, fn bank_accounts -> [bank_account | bank_accounts] end)
  end

  def deserialize(st) do
    %{st | bank_accounts: Enum.map(st.bank_accounts, &BankAccount.deserialize/1)}
  end

  def serialize(st) do
    %{st | bank_accounts: Enum.map(st.bank_accounts, &BankAccount.serialize/1)}
  end

  def initial_state() do
    %{bank_accounts: []}
  end
end
