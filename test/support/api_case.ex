defmodule Circlex.ApiCase do
  use ExUnit.CaseTemplate
  alias Circlex.Emulator.State

  using do
    quote do
    end
  end

  setup tags do
    no_load = Map.get(tags, :load) == false
    opts = Circlex.Test.get_opts(no_load: no_load)
    next = Keyword.get(opts, :next)
    initial_state = Keyword.get(opts, :initial_state)

    {:ok, state_pid} = State.start_link(name: nil, initial_state: initial_state, next: next)
    Process.put(:state_pid, state_pid)

    {:ok, state_pid: state_pid}
  end
end
