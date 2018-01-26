defmodule FreshbooksApiClient.Schema.TimeEntry do
  @moduledoc """
  This module handles metadata related to a Freshbooks TimeEntry.

  It uses a FreshbooksApiClient.Schema
  """

  use FreshbooksApiClient.Schema, resource: "time_entry",
    resources: "time_entries"

  api_schema do
    field :time_entry_id, :integer
    field :hours, :decimal
    field :date, :date
    field :notes, :string
    field :billed, :boolean

    belongs_to :staff, FreshbooksApiClient.Schema.Staff
    belongs_to :project, FreshbooksApiClient.Schema.Project
    belongs_to :task, FreshbooksApiClient.Schema.Task
  end
end
