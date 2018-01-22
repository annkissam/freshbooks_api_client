defmodule FreshbooksApiClient.API do
  @moduledoc """
  This module is the main bridge of communication with Freshbooks keeping all the
  FreshbooksApiClient settings and app configurations.

  # Usage:

    FreshbooksApiClient.API.get(FreshbooksApiClient.Employee)
  """

  @doc ~s(This function delegates to `get` function in the `caller` module)
  def get(schema, opts \\ %{}) do
    args = [schema, FreshbooksApiClient.subdomain(),
            FreshbooksApiClient.token(), opts]

    case apply(FreshbooksApiClient.caller(), :get, args) do
      {:ok, %HTTPoison.Response{body: body, status_code: 200}} -> resolve_response(schema, body)
      {:ok, %HTTPoison.Response{status_code: 401}} -> {:error, :unauthorized}
      {:error, %HTTPoison.Error{reason: _error}} -> {:error, :connection_err}
      _ -> {:error, :unknown}
    end
  end

  defp resolve_response(schema, body) do
    body
    |> Poison.decode!
    |> Enum.map(&Enum.map(&1, fn({x, y}) -> {String.to_atom(x), y} end))
    |> Enum.map(&struct(schema, &1))
  end
  # TODO need to add this for single struct vs collection
  defp resolve_response(schema, body) do
    body
    |> Poison.decode!
    |> Map.get(apply(schema, :collection_name, []))
    |> Enum.map(&Map.to_list &1)
    |> Enum.map(&Enum.map(&1, fn({x, y}) -> {String.to_atom(x), y} end))
    |> Enum.map(&struct(schema, &1))
  end
end
