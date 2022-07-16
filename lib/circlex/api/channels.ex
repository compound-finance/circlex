defmodule Circlex.Api.Channels do
  @moduledoc """
  Core API...
  """
  import Circlex.Api

  @doc ~S"""
  Retrieve a list of channels with details (e.g. cardDescriptor, achDescriptor,
  etc.).

  Reference: https://developers.circle.com/reference/listchannels

  ## Examples

      iex> host = Circlex.Test.start_server()
      iex> Circlex.Api.Channels.list_channels(host: host)
      {:error, %{error: "Not implemented by Circlex client"}}
  """
  def list_channels(opts \\ []) do
    not_implemented()
  end
end
