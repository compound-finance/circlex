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
    emulator_config = Application.get_env(:circlex, :emulator)
    signer_mfa = Keyword.fetch!(emulator_config, :signer_mfa)
    chain_id = Keyword.fetch!(emulator_config, :chain_id)
    ethereum_node = Keyword.fetch!(emulator_config, :ethereum_node)
    ethereum_remote_node = Keyword.fetch(emulator_config, :ethereum_remote_node)
    usdc_address = Signet.Util.decode_hex!(Keyword.fetch!(emulator_config, :usdc_address))

    _transfer_topic =
      Signet.Util.decode_hex!(
        "0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef"
      )

    # TODO: Should we do our USDC interactions here?
    local_filter_name = Signet.Filter.USDCDepositFilter

    local_filter_child =
      Supervisor.child_spec({Signet.Filter, [local_filter_name, ethereum_node, usdc_address, []]},
        id: local_filter_name
      )

    {filter_names, filter_children} =
      case ethereum_remote_node do
        nil ->
          {[local_filter_name], [local_filter_child]}

        {:ok, remote_node} ->
          remote_filter_name = Signet.Filter.USDCDepositRemoteFilter

          remote_filter_child =
            Supervisor.child_spec(
              {Signet.Filter, [remote_filter_name, remote_node, usdc_address, []]},
              id: remote_filter_name
            )

          {[local_filter_name, remote_filter_name], [local_filter_child, remote_filter_child]}
      end

    children =
      [
        {Plug.Cowboy,
         scheme: :http,
         plug: {Circlex.Emulator.Router, state_name},
         options: [ref: cowboy_ref, port: port]},
        {Circlex.Emulator.State, name: state_name, initial_state: initial_state, next: next},
        Supervisor.child_spec(
          {Signet.Signer, mfa: signer_mfa, chain_id: chain_id, name: Circlex.Emulator.Signer},
          id: Circlex.Emulator.Signer
        )
      ] ++
        filter_children ++
        [
          {Circlex.Emulator.DepositDetector, [filter_names, state_name]}
        ]

    Logger.info("Circlex Emulator starting on port #{port}...")
    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
