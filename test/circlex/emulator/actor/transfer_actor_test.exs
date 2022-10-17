defmodule Circlex.Emulator.Actor.TransferActorTest do
  use ExUnit.Case

  alias Circlex.Emulator.Actor.TransferActor
  alias Circlex.Emulator.State
  alias Circlex.Emulator.State.{TransferState, WalletState}
  alias Circlex.Struct.{Amount, Transfer, SourceDest, Wallet}

  @transfer_b2w %Transfer{
    amount: %Amount{amount: "10000.00", currency: "USD"},
    create_date: "2022-05-05T16:49:04.541Z",
    source: %SourceDest{
      address: "0x2eb953f992d4fa6e769fabf25d8218f21b793558",
      chain: "ETH",
      type: :blockchain
    },
    id: "83f18616-0f26-499a-aa8f-4fa4d563b974",
    destination: %SourceDest{id: "1000216185", type: :wallet},
    status: "pending",
    transaction_hash: "0xef6cf276368eb0e36162074b1c17a3256df14635c8603f076e826650c9f8a9ff"
  }

  @transfer_w2w %Transfer{
    amount: %Amount{amount: "10000.00", currency: "USD"},
    create_date: "2022-05-05T16:49:04.541Z",
    destination: %SourceDest{id: "1000216186", type: :wallet},
    id: "83f18616-0f26-499a-aa8f-4fa4d563b975",
    source: %SourceDest{id: "1000216185", type: :wallet},
    status: "pending",
    transaction_hash: nil
  }

  @transfer_w2b %Transfer{
    amount: %Amount{amount: "10000.00", currency: "USD"},
    create_date: "2022-05-05T16:49:04.541Z",
    destination: %SourceDest{
      address: "0x2eb953f992d4fa6e769fabf25d8218f21b793558",
      chain: "ETH",
      type: :blockchain
    },
    id: "83f18616-0f26-499a-aa8f-4fa4d563b975",
    source: %SourceDest{id: "1000216185", type: :wallet},
    status: "pending",
    transaction_hash: nil
  }

  setup do
    signer_proc = Signet.Test.Signer.start_signer()
    Process.put(:signer_proc, signer_proc)

    {:ok, state_pid} =
      State.start_link(Keyword.put(Circlex.Test.get_opts(), :signer_proc, signer_proc))

    Process.put(:state_pid, state_pid)

    :ok
  end

  test "blockchain in processing flow" do
    TransferState.add_transfer(@transfer_b2w)
    assert TransferState.get_transfer(@transfer_b2w.id) == {:ok, @transfer_b2w}
    {:ok, master_wallet} = WalletState.master_wallet()
    assert Wallet.get_balance(master_wallet, "USD") == "150234.93"

    {:ok, _actor} = TransferActor.start_link(@transfer_b2w.id)

    # Allow processing time
    :timer.sleep(2 * Circlex.Emulator.action_delay())

    assert TransferState.get_transfer(@transfer_b2w.id) ==
             {:ok, %{@transfer_b2w | status: "complete"}}

    {:ok, master_wallet} = WalletState.master_wallet()
    assert Wallet.get_balance(master_wallet, "USD") == "160234.93"
  end

  test "wallet to wallet processing flow" do
    TransferState.add_transfer(@transfer_w2w)
    assert TransferState.get_transfer(@transfer_w2w.id) == {:ok, @transfer_w2w}
    {:ok, master_wallet} = WalletState.master_wallet()
    assert Wallet.get_balance(master_wallet, "USD") == "150234.93"
    {:ok, dest_wallet} = WalletState.get_wallet("1000216186")
    assert Wallet.get_balance(dest_wallet, "USD") == "50.00"

    {:ok, _actor} = TransferActor.start_link(@transfer_w2w.id)

    # Allow processing time
    :timer.sleep(2 * Circlex.Emulator.action_delay())

    assert TransferState.get_transfer(@transfer_w2w.id) ==
             {:ok, %{@transfer_w2w | status: "complete"}}

    {:ok, master_wallet} = WalletState.master_wallet()
    assert Wallet.get_balance(master_wallet, "USD") == "140234.93"
    {:ok, dest_wallet} = WalletState.get_wallet("1000216186")
    assert Wallet.get_balance(dest_wallet, "USD") == "10050.00"
  end

  test "wallet to blockchain processing flow" do
    TransferState.add_transfer(@transfer_w2b)
    assert TransferState.get_transfer(@transfer_w2b.id) == {:ok, @transfer_w2b}
    {:ok, master_wallet} = WalletState.master_wallet()
    assert Wallet.get_balance(master_wallet, "USD") == "150234.93"

    {:ok, _actor} = TransferActor.start_link(@transfer_w2b.id)

    # Allow processing time
    :timer.sleep(2 * Circlex.Emulator.action_delay())

    assert TransferState.get_transfer(@transfer_w2b.id) ==
             {:ok,
              %{
                @transfer_w2b
                | status: "complete",
                  transaction_hash:
                    "0x040000000047868C0000001407865C6E87B9F70255377E024ACE6630C1EAA37F"
              }}

    {:ok, master_wallet} = WalletState.master_wallet()
    assert Wallet.get_balance(master_wallet, "USD") == "140234.93"
  end
end
