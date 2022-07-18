defmodule Circlex.Api.Channels do
  @moduledoc """
  Core API...
  """
  import Circlex.Api

  @doc ~S"""
  Retrieve a list of channels with details (e.g. cardDescriptor, achDescriptor,
  etc.).

  Reference: https://developers.circle.com/reference/listchannels

  Note: not currently implemented by Emulator.

  ## Examples

      iex> host = Circlex.Test.start_server()
      iex> Circlex.Api.Channels.list_channels(host: host)
      {:error, %{error: "not found"}}
  """
  def list_channels(opts \\ []) do
    with {:ok, channels} <-
           api_get("/v1/channels", opts) do
      {:ok,
       Enum.map(channels, fn %{
                               "id" => id,
                               "default" => default,
                               "cardDescriptor" => card_descriptor,
                               "achDescriptor" => ach_descriptor
                             } ->
         %{
           id: id,
           default: default,
           card_descriptor: card_descriptor,
           ach_descriptor: ach_descriptor
         }
       end)}
    end
  end
end
