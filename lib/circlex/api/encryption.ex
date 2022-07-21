defmodule Circlex.Api.Encryption do
  @moduledoc """
  API Client to the Encryption API.

  Note: not currently implemented.

  Reference: https://developers.circle.com/reference/getpublickey
  """

  import Circlex.Api.Tooling

  @doc ~S"""
  Retrieves an RSA public key to be used in encrypting data sent to the API.

  Reference: https://developers.circle.com/reference/getpublickey

  ## Examples

      iex> host = Circlex.Test.start_server()
      iex> Circlex.Api.Encryption.get_public_key(host: host)
      {:error, %{error: "Not implemented by Circlex client"}}
  """
  def get_public_key(_opts \\ []) do
    not_implemented()
  end
end
