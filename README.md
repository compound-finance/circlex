# Circlex

Circlex is a client libary for the Circle API, and a Circle API Server Emulator.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `circlex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:circlex, "~> 0.1.0"}
  ]
end
```

## Getting Started

### API Client

To start an API client, set-up your Circlex application by specifying the Circle host, e.g.

**runtime.exs**

```elixir
config :circlex,
  host: "https://api-sandbox.circle.com",
  auth: System.get_env("CIRCLE_AUTH")
```

Then run:

```elixir
iex> Circlex.API.Health.ping()
{:ok, %{message: "pong"}}
```

### Emulator

To run the emulator, run:

```sh
mix emulator
```

You can specify a port, and an initial state:

```
mix emulator --port 3334 --load test/support/initial_state.json
```

State can be serialized in the emulator to a file, and loaded back on start.

#### Saving State

Start an emulator, and then run:

```
curl -XPOST http://localhost:3333/circlex/save/my_state
```

That should save your state to `state/my_state.json`. You can then reload that state with:

```
mix emulator --load state/my_state.json
```

## Documentation

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/circlex>.

## Contributing

Create a PR to contribute to Circlex. All contributors agree to accept the license specified in this repository for all contributions to this project. See [LICENSE.md](/LICENSE.md).
