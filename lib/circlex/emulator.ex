defmodule Circlex.Emulator do
  @moduledoc """
  A basic server to mimic the functionality of Circle.
  """
  require Logger

  @type opt() :: {:port, integer()} | {:initial_state, term()}
  @default_port 3333

  def emulator_config(), do: Application.get_env(:circlex_api, :emulator)

  def usdc_address(),
    do: Signet.Util.decode_hex!(Keyword.fetch!(emulator_config(), :usdc_address))

  def port(), do: Keyword.get(emulator_config(), :port, @default_port)
  def merchant_id(), do: Keyword.fetch!(emulator_config(), :merchant_id)

  @transfer_event "Transfer(address indexed from, address indexed to, uint amount)"

  def action_delay(),
    do: Keyword.fetch!(emulator_config(), :action_delay_ms)

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start, [opts]},
      type: :worker,
      restart: :permanent,
      shutdown: 500
    }
  end

  @spec start() :: {:ok, pid()} | {:error, String.t()}
  @spec start([opt()]) :: {:ok, pid()} | {:error, String.t()}
  def start(opts \\ []) do
    emulator_port = Keyword.get(opts, :port, port())
    initial_state = Keyword.get(opts, :initial_state, emulator_config()[:initial_state])
    state_name = Keyword.get(opts, :state_name, Circlex.Emulator.State)
    cowboy_ref = Module.concat(__MODULE__, "Port_" <> to_string(emulator_port))
    next = Keyword.get(opts, :next, %{})
    listeners = Keyword.get(opts, :listeners, [])
    ethereum_node = Signet.Application.ethereum_node()
    signer = Keyword.get(opts, :signer, emulator_config()[:signer] || Signet.Signer.Default)

    children = [
      {Plug.Cowboy,
       scheme: :http,
       plug: {Circlex.Emulator.Router, [state_pid: state_name, signer_proc: signer]},
       options: [ref: cowboy_ref, port: emulator_port]},
      {Circlex.Emulator.State,
       name: state_name, initial_state: initial_state, next: next, signer_proc: signer},
      {Signet.Filter,
       [name: USDCDepositFilter, address: usdc_address(), events: [@transfer_event]]},
      {Circlex.Emulator.DepositDetector, [[USDCDepositFilter], state_name]},
      {Circlex.Emulator.Notifier, listeners: listeners}
    ]

    Logger.info(
      "Circlex Emulator starting on port #{emulator_port} connected to #{ethereum_node}..."
    )

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
