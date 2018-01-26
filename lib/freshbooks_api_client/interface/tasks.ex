defmodule FreshbooksApiClient.Interface.Tasks do
  @moduledoc """
  This module handles the interface operations to interact with Freshbooks
  tasks resource.

  It uses a FreshbooksApiClient.Interface
  """

  import SweetXml

  alias FreshbooksApiClient.Schema.Task

  use FreshbooksApiClient.Interface, schema: Task, allow: ~w(get list)a

  def xml_parent_spec(:list) do
    {
     ~x"//response/tasks/task"l,
      xml_spec()
    }
  end

  def xml_parent_spec(:get) do
    {
      ~x"//response/task",
      xml_spec()
    }

  end

  def xml_spec do
    [
      task_id: ~x"./task_id/text()"i,
      name: ~x"./name/text()"s,
      billable: ~x"./billable/text()"s,
      rate: ~x"./rate/text()"s,
      description: ~x"./description/text()"s,
    ]
  end

  def transform(field, params) when field in [:rate] do
    Map.update!(params, field, fn curr ->
      case curr do
        "" -> nil
        _ ->
          curr
          |> Decimal.new
      end
    end)
  end

  def transform(field, params) when field in [:billable] do
    Map.update!(params, field, &(&1 == "1"))
  end

  def transform(_field, params), do: params
end
