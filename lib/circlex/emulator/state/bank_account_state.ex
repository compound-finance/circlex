defmodule Circlex.Emulator.State.BankAccountState do
  alias Circlex.Emulator.State
  alias Circlex.Struct.BankAccount
  alias Circlex.Emulator.Logic.BankAccountLogic

  import State.Util

  def all_bank_accounts(filters \\ []) do
    get_bank_accounts_st(fn bank_accounts -> bank_accounts end, filters)
  end

  def get_bank_account(id, filters \\ []) do
    get_bank_accounts_st(
      fn bank_accounts -> BankAccountLogic.get_bank_account(bank_accounts, id) end,
      filters
    )
  end

  def get_bank_account_by_tracking_ref(tracking_ref, filters \\ []) do
    get_bank_accounts_st(
      fn bank_accounts ->
        BankAccountLogic.get_bank_account_by(bank_accounts, :tracking_ref, tracking_ref)
      end,
      filters
    )
  end

  def add_bank_account(bank_account) do
    update_bank_accounts_st(fn bank_accounts ->
      BankAccountLogic.add_bank_account(bank_accounts, bank_account)
    end)
  end

  def update_bank_account(bank_account_id, f) do
    update_bank_accounts_st(fn bank_accounts ->
      BankAccountLogic.update_bank_account(bank_accounts, bank_account_id, f)
    end)
  end

  # TODO: Test
  def new_bank_account(account_number, routing_number, billing_details, bank_address) do
    {:ok,
     %BankAccount{
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

  def deserialize(st) do
    %{st | bank_accounts: Enum.map(st.bank_accounts, &BankAccount.deserialize/1)}
  end

  def serialize(st) do
    %{st | bank_accounts: Enum.map(st.bank_accounts, &BankAccount.serialize/1)}
  end

  def initial_state() do
    %{bank_accounts: []}
  end

  defp get_bank_accounts_st(mfa_or_fn, filters \\ []) do
    State.get_st(mfa_or_fn, [:bank_accounts], &apply_filters(&1, filters))
  end

  defp update_bank_accounts_st(mfa_or_fn, filters \\ []) do
    State.update_st(mfa_or_fn, [:bank_accounts], &apply_filters(&1, filters))
  end
end
