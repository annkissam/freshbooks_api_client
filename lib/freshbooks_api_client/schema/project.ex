defmodule FreshbooksApiClient.Schema.Project do
  @moduledoc """
  This module handles metadata related to a Freshbooks Project.

  It uses a FreshbooksApiClient.Schema
  """

  use FreshbooksApiClient.Schema

  api_schema do
    field :project_id, :integer
    field :name, :string
    field :description, :string
    field :rate, :decimal
    field :bill_method, :string
    field :hour_budget, :decimal

    belongs_to :client, FreshbooksApiClient.Schema.Client

    # Figure out how to do embdes
    # embeds_many :tasks, Task
    # embeds_many :staff, Staff
  end
end
