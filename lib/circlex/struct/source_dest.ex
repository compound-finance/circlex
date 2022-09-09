defmodule Circlex.Struct.SourceDest do
  use Circlex.Struct.JasonHelper
  import Circlex.Struct.Util

  defmodule Identity do
    use Circlex.Struct.JasonHelper
    import Circlex.Struct.Util

    defstruct [:type, :name, :addresses]

    def deserialize(identity) do
      %__MODULE__{
        name: fetch(identity, :name),
        type: fetch(identity, :type),
        addresses:
          (fetch(identity, :addresses) || [])
          |> Enum.map(&Circlex.Struct.PhysicalAddress.deserialize/1)
      }
    end

    def serialize(identity) do
      %{
        name: identity.name,
        type: identity.type,
        addresses: Enum.map(identity.addresses || [], &Circlex.Struct.PhysicalAddress.serialize/1)
      }
    end
  end

  defstruct [:type, :id, :address, :address_tag, :chain, :address_id, identities: []]

  def deserialize(source_dest) do
    case fetch(source_dest, :type) do
      "wire" ->
        %__MODULE__{
          type: :wire,
          id: fetch(source_dest, :id)
        }

      "wallet" ->
        %__MODULE__{
          type: :wallet,
          id: fetch(source_dest, :id),
          address: fetch(source_dest, :address)
        }

      "blockchain" ->
        %__MODULE__{
          type: :blockchain,
          address: fetch(source_dest, :address),
          address_tag: fetch(source_dest, :addressTag),
          chain: fetch(source_dest, :chain)
        }

      "verified_blockchain" ->
        %__MODULE__{
          type: :verified_blockchain,
          address_id: fetch(source_dest, :addressId)
        }
    end
    |> Map.put(
      :identities,
      (fetch(source_dest, :identities) || [])
      |> Enum.map(&Identity.deserialize/1)
    )
  end

  def serialize(source_dest) do
    base_source_dest =
      case source_dest.type do
        :wire ->
          %{
            type: "wire",
            id: source_dest.id
          }

        :wallet ->
          Map.merge(
            %{
              type: "wallet",
              id: source_dest.id
            },
            if(is_nil(source_dest.address),
              do: %{},
              else: %{address: String.downcase(source_dest.address)}
            )
          )

        :blockchain ->
          case source_dest.chain do
            "ETH" ->
              %{
                type: "blockchain",
                address: String.downcase(source_dest.address),
                chain: source_dest.chain
              }

            _ ->
              %{
                type: "blockchain",
                address: source_dest.address,
                chain: source_dest.chain
              }
          end

        :verified_blockchain ->
          %{
            type: "verified_blockchain",
            addressId: source_dest.address_id
          }
      end

    # a bit of a mess here b/c destinations and core api transfers souerces aren't really supposed to have identities whatsoever,
    # so we drop the key from json if it is empty
    if Enum.empty?(source_dest.identities) do
      base_source_dest
    else
      Map.put(
        base_source_dest,
        :identities,
        Enum.map(source_dest.identities, &__MODULE__.Identity.serialize/1)
      )
    end
  end
end
