defmodule Circlex.Emulator.State do
  use GenServer
  require Logger

  alias Circlex.Emulator.State.{
    BankAccountState,
    PaymentState,
    PayoutState,
    RecipientState,
    SubscriptionState,
    TransferState,
    WalletState
  }

  def start_link(opts \\ []) do
    name = Keyword.get(opts, :name, __MODULE__)
    initial_state = Keyword.get(opts, :initial_state, nil)
    next = Keyword.get(opts, :next, %{})
    Logger.info("Starting Circlex.Emulator.State #{name}...")

    GenServer.start_link(
      __MODULE__,
      %{st: initial_state, next: next},
      name: name
    )
  end

  @impl true
  def init(state = %{st: st}) do
    initial_st =
      WalletState.initial_state()
      |> Map.merge(BankAccountState.initial_state())
      |> Map.merge(TransferState.initial_state())
      |> Map.merge(PaymentState.initial_state())
      |> Map.merge(PayoutState.initial_state())
      |> Map.merge(RecipientState.initial_state())
      |> Map.merge(SubscriptionState.initial_state())
      |> Map.merge(do_restore_st(st))

    # Logger.debug("Initial state: #{inspect(initial_st)}")
    {:ok, Map.put(state, :st, initial_st)}
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

  def next(type) do
    GenServer.call(get_pid(), {:next, type})
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

  def handle_cast({:restore_state, new_st}, state) do
    {:noreply, Map.put(state, :st, do_restore_st(new_st))}
  end

  defp do_restore_st(nil), do: %{}

  defp do_restore_st(st) do
    st
    |> WalletState.deserialize()
    |> BankAccountState.deserialize()
    |> TransferState.deserialize()
    |> PaymentState.deserialize()
    |> PayoutState.deserialize()
    |> RecipientState.deserialize()
    |> SubscriptionState.deserialize()
  end

  defp generate_type(:uuid), do: UUID.uuid1()
  defp generate_type(:wallet_id), do: Enum.random(1_000_000_000..1_001_000_000) |> to_string()
  defp generate_type(:date), do: DateTime.to_iso8601(DateTime.utc_now())

  defp generate_type(:tracking_ref),
    do: "CIR3KXLL" <> to_string(System.unique_integer([:positive]))

  # TODO: We could simplify this down to just transform all
  #       fn calls to be `{fn, acc}`-style, but this is easier
  #       for now, since it's less burden on the caller.
  def handle_call({:next, type}, _from, state = %{next: next}) do
    case next[type] do
      nil ->
        {:reply, generate_type(type), state}

      [] ->
        {:reply, generate_type(type), state}

      f when is_function(f) ->
        {:reply, f.(), state}

      {f, acc} when is_function(f) ->
        {v, new_acc} = f.(acc)
        {:reply, next, %{state | next: Map.put(next, type, {f, new_acc})}}

      [v | rest] ->
        {:reply, v, %{state | next: Map.put(next, type, rest)}}
    end
  end

  def handle_call(:serialize_state, _from, state = %{st: st}) do
    serialized =
      st
      |> WalletState.serialize()
      |> BankAccountState.serialize()
      |> TransferState.serialize()
      |> PaymentState.serialize()
      |> PayoutState.serialize()
      |> RecipientState.serialize()
      |> SubscriptionState.serialize()

    {:reply, serialized, state}
  end

  def handle_call({:get_in, keys, default}, _from, state = %{st: st}) do
    keys =
      case keys do
        keys when is_list(keys) ->
          keys

        key when is_atom(key) ->
          [key]
      end

    {:reply, do_get_in(st, keys, default), state}
  end

  def handle_call({:put_in, keys, val}, _from, state = %{st: st}) do
    keys =
      case keys do
        keys when is_list(keys) ->
          keys

        key when is_atom(key) ->
          [key]
      end

    {:reply, nil, %{state | st: do_put_in(st, keys, val)}}
  end

  defp do_get_in(nil, _, default), do: default
  defp do_get_in(st, [], _), do: st

  defp do_get_in(st, [k | rest], default) when is_map(st) do
    do_get_in(st[k], rest, default)
  end

  defp do_put_in(st, [key], val) when is_map(st), do: Map.put(st, key, val)

  defp do_put_in(st, [key | rest], val) when is_map(st),
    do: Map.put(st, key, do_put_in(Map.get(st, key, %{}), rest, val))
end
