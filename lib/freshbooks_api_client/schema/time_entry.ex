defmodule FreshbooksApiClient.Schema.TimeEntry do
  @moduledoc """
  This module handles metadata related to a Freshbooks TimeEntry.

  It uses a FreshbooksApiClient.Schema
  """

  use FreshbooksApiClient.Schema

  api_schema do
    field(:time_entry_id, :integer)
    field(:hours, :decimal)
    field(:date, :date)
    field(:notes, :string)
    field(:billed, :boolean)

    belongs_to(:staff, FreshbooksApiClient.Schema.Staff, references: :staff_id)
    belongs_to(:project, FreshbooksApiClient.Schema.Project, references: :project_id)
    belongs_to(:task, FreshbooksApiClient.Schema.Task, references: :task_id)
  end

  def changeset(time_entry, attrs) do
    time_entry
    |> cast(attrs, [
      :time_entry_id,
      :hours,
      :date,
      :notes,
      :billed,
      :staff_id,
      :project_id,
      :task_id
    ])
  end
end
