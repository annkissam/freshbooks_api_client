defmodule FreshbooksApiClient.Schema.Task do
  @moduledoc """
  This module handles metadata related to a Freshbooks Task.

  It uses a FreshbooksApiClient.Schema
  """

  use FreshbooksApiClient.Schema, resource: "task"

  api_schema do
    # field :id, :integer
    field :name, :string
    field :billable, :boolean
    field :rate, :float
    field :description, :string
  end
end