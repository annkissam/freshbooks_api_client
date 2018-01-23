defmodule FreshbooksApiClient.Schema.TimeEntry do
  @moduledoc """
  This module handles metadata related to a Freshbooks TimeEntry.

  It uses a FreshbooksApiClient.Schema
  """

  alias FreshbooksApiClient.Schema.{Project, Staff, Task}

  use FreshbooksApiClient.Schema, resource: "time_entry",
    resources: "time_entries"

  api_schema do
    field :time_entry_id, :integer
    field :hours, :float
    field :date, :date
    field :notes, :string
    field :billed, :boolean

    belongs_to :staff, Staff
    belongs_to :project, Project
    belongs_to :task, Task
  end
end
