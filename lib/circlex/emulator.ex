defmodule Circlex.Emulator do
  @moduledoc """
  A basic server to mimic the functionality of Circle.
  """
  require Logger

  @type opt() :: {:port, integer()} | {:initial_state, term()}
  @default_port 3333

  @spec start() :: {:ok, pid()} | {:error, String.t()}
  @spec start([opt()]) :: {:ok, pid()} | {:error, String.t()}
  def start(opts \\ []) do
    port = Keyword.get(opts, :port, @default_port)
    initial_state = Keyword.get(opts, :initial_state, nil)
    state_name = Keyword.get(opts, :state_name, Circlex.Emulator.State)
    cowboy_ref = Module.concat(__MODULE__, "Port_" <> to_string(port))
    next = Keyword.get(opts, :next, %{})

    children = [
      {Plug.Cowboy,
       scheme: :http,
       plug: {Circlex.Emulator.Router, state_name},
       options: [ref: cowboy_ref, port: port]},
      {Circlex.Emulator.State, name: state_name, initial_state: initial_state, next: next}
    ]

    Logger.info("Circlex Emulator starting on port #{port}...")
    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
