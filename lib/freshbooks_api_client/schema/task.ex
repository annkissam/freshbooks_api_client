defmodule FreshbooksApiClient.Schema.Task do
  @moduledoc """
  This module handles metadata related to a Freshbooks Task.

  It uses a FreshbooksApiClient.Schema
  """

  use FreshbooksApiClient.Schema

  api_schema do
    field :task_id, :integer
    field :name, :string
    field :billable, :boolean
    field :rate, :decimal
    field :description, :string
  end
end
