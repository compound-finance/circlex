defmodule Circlex.Struct.JasonHelper do
  defmacro __using__(_using_opts) do
    quote do
      defimpl Jason.Encoder do
        def encode(struct, jason_opts) do
          struct
          |> unquote(__CALLER__.module).serialize()
          |> Jason.Encode.map(jason_opts)
        end
      end
    end
  end
end
