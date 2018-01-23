defmodule FreshbooksApiClient.Interface.TimeEntries do
  @moduledoc """
  This module handles the interface operations to interact with Freshbooks
  time entries resource.

  It uses a FreshbooksApiClient.Interface
  """

  import SweetXml

  alias FreshbooksApiClient.Schema.TimeEntry

  @ids ~w(time_entry_id staff_id project_id task_id)a

  use FreshbooksApiClient.Interface, schema: TimeEntry

  defp transform(field, params) when field in @ids do
    Map.update!(params, field, &String.to_integer/1)
  end
  defp transform(:hours, params) do
    Map.update!(params, :hours, fn curr ->
      case curr do
        "" -> nil
        _ -> (curr |> Float.parse() |> elem(0))
      end
    end)
  end
  defp transform(:billed, params) do
    Map.update!(params, :billed, &(&1 == "1"))
  end
  defp transform(:date, params) do
    Map.update!(params, :date, fn curr ->
      case curr do
        "" -> nil
        _ -> Date.from_iso8601!(curr)
      end
    end)
  end
  defp transform(_field, params), do: params
end
