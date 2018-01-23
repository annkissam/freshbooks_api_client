defmodule FreshbooksApiClient.Schema.Project do
  @moduledoc """
  This module handles metadata related to a Freshbooks Project.

  It uses a FreshbooksApiClient.Schema
  """

  alias FreshbooksApiClient.Schema.{Client, Task, Staff}

  use FreshbooksApiClient.Schema, resource: "project"

  api_schema do
    field :project_id, :integer
    field :name, :string
    field :description, :string
    field :rate, :float
    field :bill_method, :string
    field :hour_budget, :float

    belongs_to :client, Client

    embeds_many :tasks, Task
    embeds_many :staff, Staff
  end
end
