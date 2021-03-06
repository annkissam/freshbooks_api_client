defmodule FreshbooksApiClient.Schema.Project do
  @moduledoc """
  This module handles metadata related to a Freshbooks Project.

  It uses a FreshbooksApiClient.Schema
  """

  use FreshbooksApiClient.Schema

  api_schema do
    field(:project_id, :integer)
    field(:name, :string)
    field(:description, :string)
    field(:rate, :decimal)
    field(:bill_method, :string)
    field(:hour_budget, :decimal)

    belongs_to(:client, FreshbooksApiClient.Schema.Client, references: :client_id)

    embeds_many(:tasks, FreshbooksApiClient.Schema.Task)
    embeds_many(:staff, FreshbooksApiClient.Schema.Staff)
  end

  def changeset(project, attrs) do
    project
    |> cast(attrs, [
      :project_id,
      :name,
      :description,
      :rate,
      :bill_method,
      :hour_budget,
      :client_id
    ])
    |> cast_embed(:tasks)
    |> cast_embed(:staff)
  end
end
