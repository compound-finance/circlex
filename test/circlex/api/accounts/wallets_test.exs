defmodule Circlex.Api.Accounts.WalletsTest do
  use ExUnit.Case
  alias Circlex.Api.Accounts.Wallets
  doctest Wallets

  describe "create_wallet" do
    test "re-used idempotency key" do
      host = Circlex.Test.start_server()
      idempotency_key = UUID.uuid1()

      assert {:ok, _} =
               Circlex.Api.Accounts.Wallets.create("Test Wallet",
                 host: host,
                 idempotency_key: idempotency_key
               )

      assert {:error, %{code: 409, message: "Conflicts with another request."}} =
               Circlex.Api.Accounts.Wallets.create("Test Wallet",
                 host: host,
                 idempotency_key: idempotency_key
               )
    end
  end
end
