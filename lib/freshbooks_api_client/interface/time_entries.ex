defmodule FreshbooksApiClient.Interface.TimeEntries do
  @moduledoc """
  This module handles the interface operations to interact with Freshbooks
  time entries resource.

  It uses a FreshbooksApiClient.Interface
  """

  use FreshbooksApiClient.Interface,
    schema: FreshbooksApiClient.Schema.TimeEntry,
    resources: "time_entries",
    resource: "time_entry"

  def xml_parent_spec(:list) do
    {
     ~x"//response/time_entries/time_entry"l,
      xml_spec()
    }
  end

  def xml_parent_spec(:get) do
    {
      ~x"//response/time_entry",
      xml_spec()
    }
  end

  def xml_parent_spec(:create) do
    {
      ~x"//response",
      [
        time_entry_id: ~x"./time_entry_id/text()"i,
      ]
    }
  end

  def xml_spec do
    [
      time_entry_id: ~x"./time_entry_id/text()"i,
      hours: ~x"./hours/text()"s |> transform_by(&parse_decimal/1),
      date: ~x"./date/text()"s |> transform_by(&parse_date/1),
      notes: ~x"./notes/text()"s,
      billed: ~x"./billed/text()"s |> transform_by(&parse_boolean/1),
      staff_id: ~x"./staff_id/text()"i,
      project_id: ~x"./project_id/text()"i,
      task_id: ~x"./task_id/text()"i,
    ]
  end

end
