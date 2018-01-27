defmodule FreshbooksApiClient.Interface.Projects do
  @moduledoc """
  This module handles the interface operations to interact with Freshbooks
  projects resource.

  It uses a FreshbooksApiClient.Interface
  """

  import SweetXml

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
    ]
  end

end
