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
    initial_state = Keyword.get(opts, :initial_state, %{})

    children = [
      {Plug.Cowboy, scheme: :http, plug: Circlex.Emulator.Plug, options: [port: port]},
      {Circlex.Emulator.State, initial_state: initial_state}
    ]

    Logger.info("Circlex Emulator starting on port #{port}...")
    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
