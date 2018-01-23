defmodule FreshbooksApiClient.Interface.Tasks do
  @moduledoc """
  This module handles the interface operations to interact with Freshbooks
  tasks resource.

  It uses a FreshbooksApiClient.Interface
  """

  import SweetXml

  alias FreshbooksApiClient.Schema.Task

  use FreshbooksApiClient.Interface, schema: Task, allow: ~w(get list)a

  defp transform(:task_id, params) do
    Map.update!(params, :task_id, &String.to_integer/1)
  end
  defp transform(:rate, params) do
    Map.update!(params, :rate, &String.to_float/1)
  end
  defp transform(:billable, params) do
    Map.update!(params, :billable, &(&1 == "1"))
  end
  defp transform(_field, params), do: params
end
