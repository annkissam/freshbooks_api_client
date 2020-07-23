defmodule FreshbooksApiClient.Interface.Tasks do
  @moduledoc """
  This module handles the interface operations to interact with Freshbooks
  tasks resource.

  It uses a FreshbooksApiClient.Interface
  """

  use FreshbooksApiClient.Interface,
    schema: FreshbooksApiClient.Schema.Task,
    resources: "tasks",
    resource: "task",
    allow: ~w(get list)a

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
      billable: ~x"./billable/text()"s |> transform_by(&parse_boolean/1),
      rate: ~x"./rate/text()"s |> transform_by(&parse_decimal/1),
      description: ~x"./description/text()"s
    ]
  end
end
