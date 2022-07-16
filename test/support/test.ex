defmodule Circlex.Test do
  def start_server(opts \\ []) do
    initial_state =
      case Keyword.get(opts, :no_load) do
        true ->
          %{}

        _ ->
          "test/support/initial_state.json"
          |> File.read!()
          |> Jason.decode!(keys: :atoms)
      end

    port = 11111 + System.unique_integer([:positive])
    state_name = :"State_#{port}"
    Circlex.Emulator.start(port: port, initial_state: initial_state, state_name: state_name)

    "http://localhost:#{port}"
  end
end
