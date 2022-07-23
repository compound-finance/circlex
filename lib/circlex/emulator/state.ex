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
    next = Keyword.get(opts, :next, %{})
    signer_proc = Keyword.get(opts, :signer_proc, nil)

    {initial_state, persistor} =
      case Keyword.get(opts, :initial_state, nil) do
        {:file, file} ->
          {read_file(file), nil}

        {:persist, file} ->
          {read_file(file), {:file, file}}

        els ->
          {els, nil}
      end

    Logger.info("Starting Circlex.Emulator.State #{name}...")

    GenServer.start_link(
      __MODULE__,
      %{
        st: initial_state,
        idempotency_keys: [],
        signer_proc: signer_proc,
        next: next,
        persistor: persistor
      },
      name: name
    )
  end

  @impl true
  def init(state = %{st: st, signer_proc: signer_proc}) do
    if not is_nil(signer_proc), do: Process.put(:signer_proc, signer_proc)

    initial_st =
      WalletState.initial_state()
      |> Map.merge(BankAccountState.initial_state())
      |> Map.merge(TransferState.initial_state())
      |> Map.merge(PaymentState.initial_state())
      |> Map.merge(PayoutState.initial_state())
      |> Map.merge(RecipientState.initial_state())
      |> Map.merge(SubscriptionState.initial_state())
      |> Map.merge(do_restore_st(st))

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

  def check_idempotency_key(idempotency_key) do
    GenServer.call(get_pid(), {:check_idempotency_key, idempotency_key})
  end

  def restore_state(json) do
    GenServer.cast(get_pid(), {:restore_state, json})
  end

  def serialize_state() do
    GenServer.call(get_pid(), :serialize_state)
  end

  def get_st(mfa_or_fn, keys \\ [], filter_fn \\ nil) do
    GenServer.call(get_pid(), {:get_st, mfa_or_fn, keys, filter_fn})
  end

  def update_st(mfa_or_fn, keys \\ [], filter_fn \\ nil) do
    GenServer.cast(get_pid(), {:update_st, mfa_or_fn, keys, filter_fn})
  end

  def get_in(keys, default \\ nil) do
    case get_st(fn x -> x end, keys) do
      nil ->
        default

      els ->
        els
    end
  end

  def put_in(keys, val) do
    update_st(fn _ -> val end, keys)
  end

  def persist(persistor) do
    GenServer.cast(get_pid(), {:persist, persistor})
  end

  @impl true
  def handle_cast(
        {:update_st, {mod, fun, args}, keys, filter_fn},
        state = %{st: st, persistor: persistor}
      ) do
    case apply(mod, fun, [get_val(st, keys, filter_fn) | args]) do
      {:ok, res} ->
        new_st = do_put_in(st, keys, res)
        do_persist(persistor, new_st)
        {:noreply, Map.put(state, :st, new_st)}
    end
  end

  def handle_cast({:update_st, f, keys, filter_fn}, state = %{st: st, persistor: persistor})
      when is_function(f) do
    case f.(get_val(st, keys, filter_fn)) do
      {:ok, res} ->
        new_st = do_put_in(st, keys, res)
        do_persist(persistor, new_st)
        {:noreply, Map.put(state, :st, new_st)}
    end
  end

  def handle_cast({:restore_state, new_st}, state) do
    {:noreply, Map.put(state, :st, do_restore_st(new_st))}
  end

  def handle_cast({:persist, persistor}, state = %{st: st}) do
    do_persist(st, persistor)
    {:noreply, state}
  end

  @impl true
  def handle_call({:get_st, {mod, fun, args}, keys, filter_fn}, _from, state = %{st: st}) do
    {:reply, apply(mod, fun, [get_val(st, keys, filter_fn) | args]), state}
  end

  def handle_call({:get_st, f, keys, filter_fn}, _from, state = %{st: st}) when is_function(f) do
    {:reply, f.(get_val(st, keys, filter_fn)), state}
  end

  def handle_call(
        {:check_idempotency_key, idempotency_key},
        _from,
        state = %{idempotency_keys: idempotency_keys}
      ) do
    if Enum.member?(idempotency_keys, idempotency_key) do
      {:reply, :reused_key, state}
    else
      {:reply, :ok, %{state | idempotency_keys: [idempotency_key | idempotency_keys]}}
    end
  end

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
        {:reply, v, %{state | next: Map.put(next, type, {f, new_acc})}}

      [v | rest] ->
        {:reply, v, %{state | next: Map.put(next, type, rest)}}
    end
  end

  def handle_call(:serialize_state, _from, state = %{st: st}) do
    {:reply, serialize_st(st), state}
  end

  defp get_val(st, keys, filter_fn) do
    st
    |> do_get_in(keys)
    |> apply_filter(filter_fn)
  end

  defp apply_filter(val, nil), do: val
  defp apply_filter(val, f), do: f.(val)

  defp do_get_in(st, keys, default \\ nil)
  defp do_get_in(nil, _, default), do: default
  defp do_get_in(st, [], _), do: st

  defp do_get_in(st, [k | rest], default) when is_map(st) do
    do_get_in(st[k], rest, default)
  end

  defp do_put_in(_, [], val), do: val
  defp do_put_in(st, [key], val) when is_map(st), do: Map.put(st, key, val)

  defp do_put_in(st, [key | rest], val) when is_map(st),
    do: Map.put(st, key, do_put_in(Map.get(st, key, %{}), rest, val))

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
  defp generate_type(:eth_keypair), do: Signet.Keys.generate_keypair()

  defp generate_type(:tracking_ref),
    do: "CIR3KXLL" <> to_string(System.unique_integer([:positive]))

  defp generate_type(:external_ref),
    do: "EXTREF" <> to_string(System.unique_integer([:positive]))

  defp serialize_st(st) do
    st
    |> WalletState.serialize()
    |> BankAccountState.serialize()
    |> TransferState.serialize()
    |> PaymentState.serialize()
    |> PayoutState.serialize()
    |> RecipientState.serialize()
    |> SubscriptionState.serialize()
  end

  # TODO: We could probably move this out of this process and make it best effort.
  defp do_persist({:file, file}, st) do
    st_enc =
      st
      |> serialize_st()
      |> Jason.encode!(pretty: true)

    File.write!(file, st_enc)
  end

  defp do_persist(nil, st) do
    :ok
  end

  defp read_file(file) do
    file
    |> File.read!()
    |> Jason.decode!(keys: :atoms)
  end
end
