defmodule FreshbooksApiClient.Context do
  @moduledoc """

  This is an EXAMPLE context. It's uses the EXAMPLE FreshbooksApiClient.Api,
  which is also functional. To quickly get started, feel free to use this module
  or create your own.

  # Usage:

    FreshbooksApiClient.Context.list_tasks()
  """

  # https://www.freshbooks.com/developers/docs/clients#client.list
  def list_clients() do
    FreshbooksApiClient.Api.list(FreshbooksApiClient.Interface.Clients)
  end

  def get_client!(client_id) do
    FreshbooksApiClient.Api.get!(FreshbooksApiClient.Interface.Clients, client_id: client_id)
  end

  # https://www.freshbooks.com/developers/docs/invoices#invoice.list
  def list_invoices(date: date) do
    date = Date.to_iso8601(date)

    FreshbooksApiClient.Api.list(FreshbooksApiClient.Interface.Invoices,
      date_from: date,
      date_to: date
    )
  end

  def get_invoice!(invoice_id) do
    FreshbooksApiClient.Api.get!(FreshbooksApiClient.Interface.Invoices, invoice_id: invoice_id)
  end

  # https://www.freshbooks.com/developers/docs/projects#project.list
  def list_projects() do
    FreshbooksApiClient.Api.list(FreshbooksApiClient.Interface.Projects)
  end

  def get_project!(project_id) do
    FreshbooksApiClient.Api.get!(FreshbooksApiClient.Interface.Projects, project_id: project_id)
  end

  # https://www.freshbooks.com/developers/docs/staff#staff.list
  def list_staff() do
    FreshbooksApiClient.Api.list(FreshbooksApiClient.Interface.Staff)
  end

  def get_staff!(staff_id) do
    FreshbooksApiClient.Api.get!(FreshbooksApiClient.Interface.Staff, staff_id: staff_id)
  end

  # NOTE: This requires calling list_staff and so it's not performant.
  # You should use a cached value if possible and store this response.
  def get_staff_by_email(email) do
    list_staff()
    |> Enum.find(&(&1.email == email))
  end

  # https://www.freshbooks.com/developers/docs/tasks#task.list
  def list_tasks() do
    FreshbooksApiClient.Api.list(FreshbooksApiClient.Interface.Tasks)
  end

  def get_task!(task_id) do
    FreshbooksApiClient.Api.get!(FreshbooksApiClient.Interface.Tasks, task_id: task_id)
  end

  # https://www.freshbooks.com/developers/docs/time-entries#time_entry.list
  def list_time_entries(date: date) do
    date = Date.to_iso8601(date)

    FreshbooksApiClient.Api.list(FreshbooksApiClient.Interface.TimeEntries,
      date_from: date,
      date_to: date
    )
  end

  def get_time_entry!(time_entry_id) do
    FreshbooksApiClient.Api.get!(FreshbooksApiClient.Interface.TimeEntries,
      time_entry_id: time_entry_id
    )
  end

  # {:ok, %{time_entry_id: 1578774}} | {:error, errors}
  def create_time_entry(params) do
    FreshbooksApiClient.Api.create(FreshbooksApiClient.Interface.TimeEntries, params)
  end

  # {:ok, nil} | {:error, errors}
  def update_time_entry(%{time_entry_id: time_entry_id}, params) do
    params = Map.merge(params, %{time_entry_id: time_entry_id})
    FreshbooksApiClient.Api.update(FreshbooksApiClient.Interface.TimeEntries, params)
  end

  # {:ok, nil} | {:error, errors}
  def delete_time_entry(%{time_entry_id: time_entry_id}) do
    FreshbooksApiClient.Api.delete(FreshbooksApiClient.Interface.TimeEntries,
      time_entry_id: time_entry_id
    )
  end
end
