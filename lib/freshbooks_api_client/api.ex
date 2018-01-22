defmodule FreshbooksApiClient.API do
  @moduledoc """
  This module is the main bridge of communication with Freshbooks keeping all the
  FreshbooksApiClient settings and app configurations.

  # Usage:

    FreshbooksApiClient.API.get(FreshbooksApiClient.Employee)
  """

  @doc ~s(This function delegates to `get` function in the `caller` module)
  def get(schema, opts \\ %{}) do
    {caller, opts} = Map.pop(opts, :caller, FreshbooksApiClient.caller())
    args = [schema, FreshbooksApiClient.token(), opts]

    case apply(caller, :get, args) do
      {:ok, %HTTPoison.Response{body: body, status_code: 200}} ->
        resolve_response(schema, Poison.decode!(body, keys: :atoms))
      {:ok, %HTTPoison.Response{status_code: 401}} -> {:error, :unauthorized}
      {:error, %HTTPoison.Error{reason: _error}} -> {:error, :connection_err}
      _ -> {:error, :unknown}
    end
  end

  defp resolve_response(schema, body) when is_list(body) do
    Enum.map(body, &resolve_response(schema, &1))
  end
  defp resolve_response(schema, body) do
    struct!(schema, body)
  end
end
