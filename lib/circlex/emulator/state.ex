defmodule Circlex.Emulator.State do
  use GenServer
  require Logger
  alias Circlex.Emulator.State.{Wallet}

  def start_link([]), do: start_link(initial_state: %{})

  def start_link(initial_state: initial_state),
    do: start_link(name: __MODULE__, initial_state: initial_state)

  def start_link(name: name, initial_state: initial_state) do
    Logger.info("Starting Circlex.Emulator.State #{name}...")

    GenServer.start_link(
      __MODULE__,
      initial_state,
      name: name
    )
  end

  @impl true
  def init(state) do
    initial_state = Map.merge(Wallet.initial_state(), do_restore_state(state))
    Logger.debug("Initial state: #{inspect(initial_state)}")
    {:ok, initial_state}
  end

  defp get_pid() do
    case Process.get(:state_pid) do
      pid when is_pid(pid) ->
        pid

      name when is_atom(name) and not is_nil(name) ->
        Process.whereis(name)

      nil ->
        __MODULE__
    end
  end

  def restore_state(json) do
    GenServer.cast(get_pid(), {:restore_state, json})
  end

  def serialize_state() do
    GenServer.call(get_pid(), :serialize_state)
  end

  def get_in(keys, default \\ nil) do
    GenServer.call(get_pid(), {:get_in, keys, default})
  end

  def put_in(keys, val) do
    GenServer.call(get_pid(), {:put_in, keys, val})
  end

  def update_in(keys, updater, default \\ nil) do
    curr = __MODULE__.get_in(keys, default)
    next = updater.(curr)
    __MODULE__.put_in(keys, next)
  end

  def handle_cast({:restore_state, new_state}, _state) do
    {:noreply, do_restore_state(new_state)}
  end

  defp do_restore_state(st) do
    st
    |> Wallet.deserialize()
  end

  def handle_call(:serialize_state, _from, state) do
    {:reply, state |> Wallet.serialize(), state}
  end

  def handle_call({:get_in, keys, default}, _from, state) do
    keys =
      case keys do
        keys when is_list(keys) ->
          keys

        key when is_atom(key) ->
          [key]
      end

    {:reply, do_get_in(state, keys, default), state}
  end

  def handle_call({:put_in, keys, val}, _from, state) do
    keys =
      case keys do
        keys when is_list(keys) ->
          keys

        key when is_atom(key) ->
          [key]
      end

    {:reply, nil, do_put_in(state, keys, val)}
  end

  defp do_get_in(nil, _, default), do: default
  defp do_get_in(state, [], _), do: state

  defp do_get_in(state, [k | rest], default) when is_map(state) do
    do_get_in(state[k], rest, default)
  end

  defp do_put_in(state, [key], val) when is_map(state), do: Map.put(state, key, val)

  defp do_put_in(state, [key | rest], val) when is_map(state),
    do: Map.put(state, key, do_put_in(Map.get(state, key, %{}), rest, val))
end
