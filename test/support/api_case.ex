defmodule Circlex.ApiCase do
  use ExUnit.CaseTemplate
  alias Circlex.Emulator.State

  using do
    quote do
    end
  end

  setup tags do
    initial_state =
      case Map.get(tags, :load) do
        false ->
          %{}

        _ ->
          "test/support/initial_state.json"
          |> File.read!()
          |> Jason.decode!(keys: :atoms)
      end

    {:ok, state_pid} = State.start_link(name: nil, initial_state: initial_state)
    Process.put(:state_pid, state_pid)

    {:ok, state_pid: state_pid}
  end
end
