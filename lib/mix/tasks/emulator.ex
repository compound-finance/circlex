defmodule Mix.Tasks.Emulator do
  @moduledoc """
  Starts the Emulator.
  """
  use Mix.Task
  @requirements ["app.start"]

  @shortdoc "Start the Circlex Emulator."
  def run(args) do
    opts = parse_args(args)
    {:ok, pid} = Circlex.Emulator.start(opts)
    Process.link(pid)
    :timer.sleep(:infinity)
  end

  defp parse_args(args), do: do_parse_args(args, [])

  defp do_parse_args([], opts), do: opts

  defp do_parse_args(["--port", port | rest], opts), do: do_set_port(port, rest, opts)
  defp do_parse_args(["-p", port | rest], opts), do: do_set_port(port, rest, opts)

  defp do_parse_args(["--load", file | rest], opts), do: do_load_file(file, rest, opts)
  defp do_parse_args(["-l", file | rest], opts), do: do_load_file(file, rest, opts)

  defp do_set_port(port, rest, opts) do
    {port_int, ""} = Integer.parse(port)
    do_parse_args(rest, Keyword.put(opts, :port, port_int))
  end

  defp do_load_file(file, rest, opts) do
    do_parse_args(rest, Keyword.put(opts, :initial_state, {:file, file}))
  end
end
