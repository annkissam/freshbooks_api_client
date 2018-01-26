defmodule FreshbooksApiClient.Interface.TimeEntries do
  @moduledoc """
  This module handles the interface operations to interact with Freshbooks
  time entries resource.

  It uses a FreshbooksApiClient.Interface
  """

  import SweetXml

  alias FreshbooksApiClient.Schema.TimeEntry

  use FreshbooksApiClient.Interface, schema: TimeEntry

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

  def xml_spec do
    [
      time_entry_id: ~x"./time_entry_id/text()"i,
      hours: ~x"./hours/text()"s,
      date: ~x"./date/text()"s,
      notes: ~x"./notes/text()"s,
      billed: ~x"./billed/text()"s,
      staff_id: ~x"./staff_id/text()"i,
      project_id: ~x"./project_id/text()"i,
      task_id: ~x"./task_id/text()"i,
    ]
  end

  def transform(field, params) when field in [:hours] do
    Map.update!(params, field, fn curr ->
      case curr do
        "" -> nil
        _ ->
          curr
          |> Decimal.new
      end
    end)
  end

  def transform(field, params) when field in [:date] do
    Map.update!(params, field, fn curr ->
      case curr do
        "" -> nil
        _ ->
          # Some date's also have a time component: 2018-01-01 00:00:00
          String.split(curr, " ")
          |> List.first
          |> Date.from_iso8601!
      end
    end)
  end

  def transform(field, params) when field in [:billed] do
    Map.update!(params, field, &(&1 == "1"))
  end

  def transform(_field, params), do: params
end
