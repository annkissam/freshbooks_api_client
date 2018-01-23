defmodule FreshbooksApiClient.Interface.Projects do
  @moduledoc """
  This module handles the interface operations to interact with Freshbooks
  projects resource.

  It uses a FreshbooksApiClient.Interface
  """

  import SweetXml

  alias FreshbooksApiClient.Schema.Project

  use FreshbooksApiClient.Interface, schema: Project, allow: ~w(get list)a

  @ids ~w(project_id client_id)a

  defp transform(field, params) when field in @ids do
    Map.update!(params, field, fn curr ->
      case curr do
        "" -> nil
        _ -> String.to_integer(curr)
      end
    end)
  end
  defp transform(:hour_budget, params) do
    Map.update!(params, :hour_budget, fn curr ->
      case curr do
        "" -> nil
        _ -> (curr |> Float.parse() |> elem(0))
      end
    end)
  end
  defp transform(:rate, params) do
    Map.update!(params, :rate, fn curr ->
      case curr do
        "" -> nil
        _ -> (curr |> Float.parse() |> elem(0))
      end
    end)
  end
  defp transform(_field, params), do: params
end
