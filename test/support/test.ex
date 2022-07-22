defmodule Circlex.Test do
  def get_opts(opts \\ []) do
    initial_state =
      case Keyword.get(opts, :no_load) do
        true ->
          nil

        _ ->
          {:file, "test/support/initial_state.json"}
      end

    port = 11111 + System.unique_integer([:positive])
    state_name = :"State_#{port}"

    next =
      Keyword.get(opts, :next, %{
        uuid: [
          "a033a6d8-05ae-11ed-9e62-6a1733211c00",
          "b09eb536-05ae-11ed-aaa8-6a1733211c01",
          "c0d3d5e0-05ae-11ed-99c0-6a1733211c01"
        ],
        wallet_id: ["1000000500", "1000000501", "1000000502"],
        date: fn -> "2022-07-17T08:59:41.344582Z" end,
        tracking_ref: ["CIR3KXZZ00", "CIR3KXZZ01", "CIR3KXZZ02"],
        eth_keypair: [
          {<<93, 46, 74, 39, 17, 3, 16, 12, 141, 212, 99, 163, 34, 158, 159, 187, 126, 7, 159,
             80>>,
           <<138, 188, 117, 102, 29, 10, 220, 76, 146, 255, 224, 189, 147, 170, 123, 117, 245,
             233, 203, 54, 29, 173, 66, 196, 169, 148, 65, 232, 223, 235, 76, 223>>}
        ]
      })

    [port: port, initial_state: initial_state, state_name: state_name, next: next]
  end

  def start_server(opts \\ []) do
    opts = get_opts(opts)
    Circlex.Emulator.start(opts)

    "http://localhost:#{Keyword.get(opts, :port)}"
  end
end
