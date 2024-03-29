defmodule Circlex.Api.Payments.BankAccounts do
  @moduledoc """
  API Client to the Payments Bank Accounts API.

  Reference: https://developers.circle.com/reference/payments-bank-accounts-wires-create
  """

  import Circlex.Api.Tooling

  alias Circlex.Struct.BankAccount

  @doc ~S"""
  Create a bank account (wires).

  Reference: https://developers.circle.com/reference/payments-bank-accounts-wires-create

  ## Examples

      iex> host = Circlex.Test.start_server()
      iex> billing_details = %{city: "Toronto", country: "CA", district: "ON", line1: "100 Money St", name: "Satoshi Nakamoto", postalCode: "ON M5J 1S9"}
      iex> bank_address = %{bankName: "HSBC Canada", city: "Toronto", country: "CA"}
      iex> Circlex.Api.Payments.BankAccounts.create("1000000001", "999999999", billing_details, bank_address, host: host)
      {
        :ok,
        %Circlex.Struct.BankAccount{
          description: "HSBC Canada 0001",
          bank_address: %{"bankName" => "HSBC Canada", "city" => "Toronto", "country" => "CA"},
          billing_details: %{"city" => "Toronto", "country" => "CA", "district" => "ON", "line1" => "100 Money St", "name" => "Satoshi Nakamoto", "postalCode" => "ON M5J 1S9"},
          create_date: "2022-07-17T08:59:41.344582Z",
          fingerprint: "b09eb536-05ae-11ed-aaa8-6a1733211c01",
          id: "a033a6d8-05ae-11ed-9e62-6a1733211c00",
          status: "pending",
          tracking_ref: "CIR3KXZZ00",
          update_date: "2022-07-17T08:59:41.344582Z"
        }
      }

  """

  def create(account_number, routing_number, billing_details, bank_address, opts \\ []) do
    idempotency_key = Keyword.get(opts, :idempotency_key, UUID.uuid1())

    with {:ok, bank_account} <-
           api_post(
             "/v1/banks/wires",
             %{
               idempotencyKey: idempotency_key,
               accountNumber: account_number,
               routingNumber: routing_number,
               billingDetails: billing_details,
               bankAddress: bank_address
             },
             opts
           ) do
      {:ok, BankAccount.deserialize(bank_account)}
    end
  end

  @doc """
  Create a bank account (wires) for an international bank account that supports list_bank_accounts

  Reference: https://developers.circle.com/reference/payments-bank-accounts-wires-create, see body params section for NON US BANK ACCOUNT - IBAN SUPPORTED

  ## Examples

    iex> host = Circlex.Test.start_server()
    iex> billing_details = %{city: "Toronto", country: "CA", district: "ON", line1: "100 Money St", name: "Satoshi Nakamoto", postalCode: "ON M5J 1S9"}
    iex> bank_address = %{bankName: "HSBC Canada", city: "Toronto", country: "CA"}
    iex> Circlex.Api.Payments.BankAccounts.create_non_us_iban_supported("1000000001", billing_details, bank_address, host: host)
    {
      :ok,
      %Circlex.Struct.BankAccount{
        description: "HSBC Canada 0001",
        bank_address: %{"bankName" => "HSBC Canada", "city" => "Toronto", "country" => "CA"},
        billing_details: %{"city" => "Toronto", "country" => "CA", "district" => "ON", "line1" => "100 Money St", "name" => "Satoshi Nakamoto", "postalCode" => "ON M5J 1S9"},
        create_date: "2022-07-17T08:59:41.344582Z",
        fingerprint: "b09eb536-05ae-11ed-aaa8-6a1733211c01",
        id: "a033a6d8-05ae-11ed-9e62-6a1733211c00",
        status: "pending",
        tracking_ref: "CIR3KXZZ00",
        update_date: "2022-07-17T08:59:41.344582Z"
      }
    }
  """
  @spec create_non_us_iban_supported(String.t(), map(), map(), list()) ::
          {:ok, %BankAccount{}} | {:error, term}
  def create_non_us_iban_supported(iban, billing_details, bank_address, opts \\ []) do
    idempotency_key = Keyword.get(opts, :idempotency_key, UUID.uuid1())

    with {:ok, bank_account} <-
           api_post(
             "/v1/banks/wires",
             %{
               idempotencyKey: idempotency_key,
               iban: iban,
               billingDetails: billing_details,
               bankAddress: bank_address
             },
             opts
           ) do
      {:ok, BankAccount.deserialize(bank_account)}
    end
  end

  @doc ~S"""
  Get a list of bank accounts (wires).

  Reference: https://developers.circle.com/reference/getbusinessaccountwirebankaccount

  ## Examples

      iex> host = Circlex.Test.start_server()
      iex> Circlex.Api.Payments.BankAccounts.list_bank_accounts(host: host)
      {
        :ok,
        [
          %Circlex.Struct.BankAccount{
            description: "HSBC Canada ****4444",
            bank_address: %{"bankName" => "HSBC Canada", "city" => "Toronto", "country" => "CA"},
            billing_details: %{"city" => "Toronto", "country" => "CA", "district" => "ON", "line1" => "100 Money St", "name" => "Satoshi Nakamoto", "postalCode" => "ON M5J 1S9"},
            create_date: "2022-02-14T22:29:32.779Z",
            fingerprint: "b296029f-8ec2-49bf-9b11-22ba09973c49",
            id: "fce6d303-2923-43cf-a66a-1e4690e08d1b",
            status: "complete",
            tracking_ref: "CIR3KX3L99",
            update_date: "2022-02-14T22:29:33.516Z"
          }
        ]
      }
  """
  def list_bank_accounts(opts \\ []) do
    with {:ok, bank_accounts} <- api_get("/v1/banks/wires", opts) do
      {:ok, Enum.map(bank_accounts, &BankAccount.deserialize/1)}
    end
  end

  @doc ~S"""
  Get a bank account (wires)

  Reference: https://developers.circle.com/reference/getbusinessaccountwirebankaccounts

  ## Examples

      iex> host = Circlex.Test.start_server()
      iex> Circlex.Api.Payments.BankAccounts.get_bank_account("fce6d303-2923-43cf-a66a-1e4690e08d1b", host: host)
      {
        :ok,
        %Circlex.Struct.BankAccount{
          description: "HSBC Canada ****4444",
          bank_address: %{"bankName" => "HSBC Canada", "city" => "Toronto", "country" => "CA"},
          billing_details: %{"city" => "Toronto", "country" => "CA", "district" => "ON", "line1" => "100 Money St", "name" => "Satoshi Nakamoto", "postalCode" => "ON M5J 1S9"},
          create_date: "2022-02-14T22:29:32.779Z",
          fingerprint: "b296029f-8ec2-49bf-9b11-22ba09973c49",
          id: "fce6d303-2923-43cf-a66a-1e4690e08d1b",
          status: "complete",
          tracking_ref: "CIR3KX3L99",
          update_date: "2022-02-14T22:29:33.516Z"
        }
      }
  """
  def get_bank_account(id, opts \\ []) do
    with {:ok, bank_account} <-
           api_get(Path.join("/v1/banks/wires", to_string(id)), opts) do
      {:ok, BankAccount.deserialize(bank_account)}
    end
  end
end
