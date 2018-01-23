defmodule FreshbooksApiClient.Interface.Tasks do
  @moduledoc """
  This module handles the interface operations to interact with Freshbooks
  tasks resource.

  It uses a FreshbooksApiClient.Interface
  """

  import SweetXml

  alias FreshbooksApiClient.Schema.Task

  use FreshbooksApiClient.Interface, schema: Task, allow: ~w(get list)a

  def translate(_, _, {:error, :unauthorized}), do: raise "Unauthorized!"
  def translate(_, _, {:error, :conn}), do: raise "HTTP Connection Error!"
  def translate(FreshbooksApiClient.Caller.HttpXml, :get, {:ok, xml}) do
    xml
    |> xpath(
      ~x"//response/task",
      task_id: ~x"./task_id/text()"s,
      name: ~x"./name/text()"s,
      description: ~x"./description/text()"s,
      billable: ~x"./billable/text()"s,
      rate: ~x"./rate/text()"s)
    |> to_schema()

  end
  def translate(FreshbooksApiClient.Caller.HttpXml, :list, {:ok, xml}) do
    xml
    |> xpath(
      ~x"//response/tasks/task"l,
      [task_id: ~x"./task_id/text()"s,
      name: ~x"./name/text()"s,
      description: ~x"./description/text()"s,
      billable: ~x"./billable/text()"s,
      rate: ~x"./rate/text()"s])
    |> Enum.each(&to_schema/1)
  end

  defp to_schema(params) do
    castable_params = :fields
      |> Task.__schema__()
      |> Enum.reduce(params, &transform/2)

    struct!(Task, castable_params)
  end

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
