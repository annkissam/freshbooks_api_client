defmodule FreshbooksApiClient.Interface.Projects do
  @moduledoc """
  This module handles the interface operations to interact with Freshbooks
  projects resource.

  It uses a FreshbooksApiClient.Interface
  """

  import SweetXml

  alias FreshbooksApiClient.Schema.Project

  use FreshbooksApiClient.Interface, schema: Project, allow: ~w(get list)a

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
      rate: ~x"./rate/text()"s,
      bill_method: ~x"./bill_method/text()"s,
      hour_budget: ~x"./hour_budget/text()"s,
      client_id: ~x"./client_id/text()"Io,
    ]
  end

  def transform(field, params) when field in [:hour_budget, :rate] do
    Map.update!(params, field, fn curr ->
      case curr do
        "" -> nil
        _ ->
          curr
          |> Decimal.new
      end
    end)
  end

  def transform(_field, params), do: params
end
