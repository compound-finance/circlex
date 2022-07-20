defmodule Circlex.Emulator do
  @moduledoc """
  A basic server to mimic the functionality of Circle.
  """
  require Logger

  @type opt() :: {:port, integer()} | {:initial_state, term()}
  @default_port 3333

  def emulator_config(), do: Application.get_env(:circlex, :emulator)
  def usdc_address(), do: Signet.Util.decode_hex!(Keyword.fetch!(emulator_config, :usdc_address))

  @transfer_event "Transfer(address indexed from, address indexed to, uint amount)"

  def action_delay(),
    do: Keyword.fetch!(Application.get_env(:circlex, :emulator), :action_delay_ms)

  @spec start() :: {:ok, pid()} | {:error, String.t()}
  @spec start([opt()]) :: {:ok, pid()} | {:error, String.t()}
  def start(opts \\ []) do
    port = Keyword.get(opts, :port, @default_port)
    initial_state = Keyword.get(opts, :initial_state, nil)
    state_name = Keyword.get(opts, :state_name, Circlex.Emulator.State)
    cowboy_ref = Module.concat(__MODULE__, "Port_" <> to_string(port))
    next = Keyword.get(opts, :next, %{})
    listeners = Keyword.get(opts, :listeners, [])
    ethereum_node = Signet.Application.ethereum_node()

    children = [
      {Plug.Cowboy,
       scheme: :http,
       plug: {Circlex.Emulator.Router, state_name},
       options: [ref: cowboy_ref, port: port]},
      {Circlex.Emulator.State, name: state_name, initial_state: initial_state, next: next},
      {Signet.Filter,
       [name: USDCDepositFilter, address: usdc_address(), events: [@transfer_event]]},
      {Circlex.Emulator.DepositDetector, [[USDCDepositFilter], state_name]},
      {Circlex.Emulator.Notifier, listeners: listeners}
    ]

    Logger.info("Circlex Emulator starting on port #{port} connected to #{ethereum_node}...")
    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
