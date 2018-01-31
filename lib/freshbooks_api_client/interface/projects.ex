defmodule FreshbooksApiClient.Interface.Projects do
  @moduledoc """
  This module handles the interface operations to interact with Freshbooks
  projects resource.

  It uses a FreshbooksApiClient.Interface
  """

  use FreshbooksApiClient.Interface,
    schema: FreshbooksApiClient.Schema.Project,
    resources: "projects",
    resource: "project",
    allow: ~w(get list)a

  def xml_parent_spec(:list) do
    {
      ~x"//response/projects/project"l,
      xml_spec()
    }
  end

  def xml_parent_spec(:get) do
    {
      ~x"//response/project",
      xml_spec()
    }
  end

  def xml_spec do
    [
      project_id: ~x"./project_id/text()"i,
      name: ~x"./name/text()"s,
      description: ~x"./description/text()"s,
      rate: ~x"./rate/text()"s |> transform_by(&parse_decimal/1),
      bill_method: ~x"./bill_method/text()"s,
      hour_budget: ~x"./hour_budget/text()"s |> transform_by(&parse_decimal/1),
      client_id: ~x"./client_id/text()"Io,
      tasks: ~x"./tasks/task"l |> transform_by(&parse_tasks/1),
      staff: ~x"./staff/staff"l |> transform_by(&parse_staff/1),
    ]
  end

  def parse_tasks(xmls) do
    Enum.map(xmls, fn(xml) ->
      xmap(xml,
        task_id: ~x"./task_id/text()"i,
        rate: ~x"./rate/text()"So |> transform_by(&parse_decimal/1),
      )
    end)
  end

  def parse_staff(xmls) do
    Enum.map(xmls, fn(xml) ->
      xmap(xml,
        staff_id: ~x"./staff_id/text()"i,
      )
    end)
  end

end
