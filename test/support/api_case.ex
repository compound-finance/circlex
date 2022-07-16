defmodule Circlex.ApiCase do
  use ExUnit.CaseTemplate
  alias Circlex.Emulator.State

  using do
    quote do
    end
  end

  setup tags do
    "test/support/initial_state.json"
    |> File.read!()
    |> Jason.decode!(keys: :atoms)

    {:ok, state_pid} = State.start_link(name: nil, initial_state: %{})
    Process.put(:state_pid, state_pid)

    IO.inspect(State.serialize_state())

    {:ok, state_pid: state_pid}
  end
end
