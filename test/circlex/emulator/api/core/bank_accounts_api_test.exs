defmodule Circlex.Emulator.Api.Core.BankAccountsApiTest do
  use Circlex.ApiCase
  alias Circlex.Emulator.Api.Core.BankAccountsApi
  doctest BankAccountsApi

  test "create_bank_account/1" do
    assert {:ok,
            %{
              bankAddress: %{
                bankName: "HSBC",
                city: "Toronto",
                country: "CA",
                district: "ON",
                line1: "101 Money St",
                name: "Satoshi Nakamoto",
                postalCode: "ON M5J 1S9"
              },
              billingDetails: %{
                city: "Toronto",
                country: "CA",
                district: "ON",
                line1: "100 Money St",
                name: "Satoshi Nakamoto",
                postalCode: "ON M5J 1S9"
              },
              createDate: "2022-07-17T08:59:41.344582Z",
              description: "HSBC 0001",
              fingerprint: "b09eb536-05ae-11ed-aaa8-6a1733211c01",
              id: "a033a6d8-05ae-11ed-9e62-6a1733211c00",
              status: "pending",
              trackingRef: "CIR3KXZZ00",
              updateDate: "2022-07-17T08:59:41.344582Z"
            }} ==
             BankAccountsApi.create_bank_account(%{
               idempotencyKey: UUID.uuid1(),
               accountNumber: "1000000001",
               routingNumber: "999999999",
               billingDetails: %{
                 city: "Toronto",
                 country: "CA",
                 district: "ON",
                 line1: "100 Money St",
                 name: "Satoshi Nakamoto",
                 postalCode: "ON M5J 1S9"
               },
               bankAddress: %{
                 bankName: "HSBC",
                 city: "Toronto",
                 country: "CA",
                 district: "ON",
                 line1: "101 Money St",
                 name: "Satoshi Nakamoto",
                 postalCode: "ON M5J 1S9"
               }
             })
  end

  test "list_bank_accounts/1" do
    assert {:ok,
            [
              %{
                description: "HSBC Canada ****4444",
                bankAddress: %{bankName: "HSBC Canada", city: "Toronto", country: "CA"},
                billingDetails: %{
                  city: "Toronto",
                  country: "CA",
                  district: "ON",
                  line1: "100 Money St",
                  name: "Satoshi Nakamoto",
                  postalCode: "ON M5J 1S9"
                },
                createDate: "2022-02-14T22:29:32.779Z",
                fingerprint: "b296029f-8ec2-49bf-9b11-22ba09973c49",
                id: "fce6d303-2923-43cf-a66a-1e4690e08d1b",
                status: "complete",
                trackingRef: "CIR3KX3L99",
                updateDate: "2022-02-14T22:29:33.516Z"
              }
            ]} == BankAccountsApi.list_bank_accounts(%{})
  end

  test "get_bank_account/1" do
    assert {:ok,
            %{
              description: "HSBC Canada ****4444",
              bankAddress: %{bankName: "HSBC Canada", city: "Toronto", country: "CA"},
              billingDetails: %{
                city: "Toronto",
                country: "CA",
                district: "ON",
                line1: "100 Money St",
                name: "Satoshi Nakamoto",
                postalCode: "ON M5J 1S9"
              },
              createDate: "2022-02-14T22:29:32.779Z",
              fingerprint: "b296029f-8ec2-49bf-9b11-22ba09973c49",
              id: "fce6d303-2923-43cf-a66a-1e4690e08d1b",
              status: "complete",
              trackingRef: "CIR3KX3L99",
              updateDate: "2022-02-14T22:29:33.516Z"
            }} ==
             BankAccountsApi.get_bank_account(%{
               bank_account_id: "fce6d303-2923-43cf-a66a-1e4690e08d1b"
             })
  end
end
