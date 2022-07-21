defmodule Circlex.Struct.SourceDest do
  import Circlex.Struct.Util

  defstruct [:type, :id, :address, :address_tag, :chain, :address_id]

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
  end

  def serialize(source_dest) do
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
            else: %{address: Signet.Util.checksum_address(source_dest.address)}
          )
        )

      :blockchain ->
        case source_dest.chain do
          "ETH" ->
            %{
              type: "blockchain",
              address: Signet.Util.checksum_address(source_dest.address),
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
  end
end
