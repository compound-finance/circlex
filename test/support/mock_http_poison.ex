defmodule MockHTTPoison do
  def post(_endpoint, _body, _headers) do
    {:ok, %HTTPoison.Response{status_code: 200}}
  end
end