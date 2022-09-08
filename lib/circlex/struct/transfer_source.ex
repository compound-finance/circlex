defmodule Circlex.Struct.TransferSource do
  use Circlex.Struct.JasonHelper
  import Circlex.Struct.Util

  defstruct [:type, :id, :address, :address_tag, :chain, :address_id, :identities]

  def deserialize(source) do
    source
    |> Circlex.Struct.TransferDestination.deserialize()
    # small hack since Source is a superset of Destination fields
    |> Map.put(:__struct__, __MODULE__)
    |> Map.put(
      :identities,
      source
      |> fetch(:identities)
      |> Enum.map(&__MODULE__.Identity.deserialize/1)
    )
  end

  def serialize(source) do
    source
    |> Circlex.Struct.TransferDestination.serialize()
    |> Map.put(
      :identities,
      Enum.map(source.identities , &__MODULE__.Identity.serialize/1)
    )
  end

  defmodule Identity do
    use Circlex.Struct.JasonHelper
    import Circlex.Struct.Util

    defstruct [:type, :name, :addresses]

    def deserialize(identity) do
      %__MODULE__{
        name: fetch(identity, :name),
        type: fetch(identity, :type),
        addresses: fetch(identity, :addresses)
      }
    end

    def serialize(source) do
        %{
          name: source.name,
          type: source.type,
          addresses: source.addresses
    }
    end
  end
end
