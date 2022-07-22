# Circlex 🪐

Circlex is a client libary for the Circle API, and a Circle API Server emulator. You can use Circlex's API client to get or post to the Circle API (e.g. in the sandbox, production). You can alternatively run a Circle API Emulator, that will act like a Circle server, accepting transfers, wires, managing wallet balances, and sending and receiving USDC transfers. This emulator can be run on a test-net (e.g. Goerli) or a local Ethereum net (e.g. Anvil, possibly forking Goerli).

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `circlex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:circlex_api, "~> 0.1.0"}
  ]
end
```

## Getting Started

### API Client

To start an API client, set-up your Circlex application by specifying the Circle host, e.g.

**runtime.exs**

```elixir
config :circlex_api,
  host: "https://api-sandbox.circle.com",
  auth: System.get_env("CIRCLE_AUTH")
```

Then you can run in your application:

```elixir
> Circlex.API.Health.ping()
{:ok, %{message: "pong"}}
```

### Emulator 🦦

To run the emulator, run:

```sh
mix emulator
```

You can specify a port, and an initial state:

```
mix emulator --port 3333 --load test/support/initial_state.json
```

State can be serialized in the emulator to a file, and loaded back on start.

#### Configuring the Emulator

You can specify the following environment variables to configure the emulator:

```sh
USDC_ADDRESS={address of USDC token}
USDC_HOLDER_PK={private key of USDC holder}
ETHEREUM_REMOTE_NODE={ethereum node to attach to}
```

The emulator expects to have the `USDC_HOLDER_PK` hold sufficient USDC to be able to make transfers out, otherwise they will fail. You can use a local deployment of USDC e.g. via [Anvil](https://book.getfoundry.sh/reference/anvil/), Hardhat or testrpc. The only requirement is that an ERC-20 token exists and the holder has sufficient funds of it. (That is, we do not mint tokens, we just take them from the holder).

Note, you use a fork of Goerli to run the emulator on, just start [Anvil](https://book.getfoundry.sh/reference/anvil/) with:

```sh
anvil --fork-url https://goerli.infura.io/
```

and then specify:

```sh
USDC_ADDRESS="0x07865c6e87b9f70255377e024ace6630c1eaa37f"
USDC_HOLDER_PK={private key of USDC holder}
ETHEREUM_REMOTE_NODE="http://localhost:8085"
```

In a local fork, you will not need to worry about sending away your Goerli USDC.

#### Persisting State

Start an emulator, and then run:

```
curl -XPOST http://localhost:3333/circlex/save/my_state
```

That should save your state to `state/my_state.json`. You can then reload that state with:

```
mix emulator --load state/my_state.json
```

You can also persist state after every change by running:

```
mix emulator --persist state/my_state.json
```

This will load and store the state with that JSON file so it's always in sync. This is not done particularly efficiently, so buyer beware. 

## Documentation

Full documentation can be found at <https://hexdocs.pm/circlex>.

### Client Features

The following APIs are supported by the API client:

 - [x] Health API
 - [x] Management API
 - [ ] Encryption API
 - [x] Subscriptions API
 - [ ] Channels API
 - [x] Stablecoins API
 - [x] Core - Balances API
 - [x] Core - Payouts API
 - [x] Core - Bank Accounts API
 - [x] Core - Transfers API
 - [x] Core - Addresses API
 - [ ] Core - Deposits API
 - [x] Payments - Payments API
 - [ ] Payments - Cards API
 - [x] Payments - Bank Accounts API
 - [ ] Payments - On-chain Payments API
 - [ ] Payments - Settlements API
 - [ ] Payments - Chargebacks API
 - [ ] Payments - Reversals API
 - [ ] Payments - Balances API
 - [x] Payouts - Payouts API
 - [x] Payouts - Bank Accounts API
 - [x] Payouts - Transfers API
 - [ ] Payouts - Returns API
 - [x] Accounts - Wallets API
 - [ ] Accounts - Transfers API

### Emulator Features

The following APIs are supported by the emulator:

 - [x] Health API
 - [x] Management API
 - [ ] Encryption API
 - [x] Subscriptions API
 - [ ] Channels API
 - [x] Stablecoins API (*partial)
 - [x] Core - Balances API
 - [x] Core - Payouts API
 - [x] Core - Bank Accounts API
 - [x] Core - Transfers API
 - [x] Core - Addresses API
 - [ ] Core - Deposits API
 - [x] Payments - Payments API
 - [ ] Payments - Cards API
 - [x] Payments - Bank Accounts API
 - [ ] Payments - On-chain Payments API
 - [ ] Payments - Settlements API
 - [ ] Payments - Chargebacks API
 - [ ] Payments - Reversals API
 - [ ] Payments - Balances API
 - [x] Payouts - Payouts API
 - [x] Payouts - Bank Accounts API
 - [x] Payouts - Transfers API
 - [ ] Payouts - Returns API
 - [x] Accounts - Wallets API
 - [x] Accounts - Transfers API
 - [x] Mocks (Wire) API

Additionally, the emulator has the features:

```md
 * Payment Actor
 * Payout Actor
 * Transfer Actor
```

These actors follow the flows of a payment, payout or transfer from "pending" to "complete" possibly sending on-chain USDC transfers, etc, to match the role of a real Circle server.

## Contributing

Create a pull request to contribute to Circlex. All contributors agree to accept the license specified in this repository for all contributions to this project. See [LICENSE.md](./LICENSE.md).
