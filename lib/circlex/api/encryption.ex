defmodule Circlex.Api.Encryption do
  @moduledoc """
  Core API...
  """
  import Circlex.Api

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
