defmodule FreshbooksApiClient.Context do
  @moduledoc """
  This module is the main bridge of communication with Freshbooks keeping all the
  FreshbooksApiClient settings and app configurations.

  # Usage:

    FreshbooksApiClient.Context.list_tasks()
  """

  # config :freshbooks_api_client, FreshbooksApiClient.Context,
  #   caller: FreshbooksApiClient.Caller.HttpXml
  #   token: System.get_env("FRESHBOOKS_API_TOKEN"),
  #   subdomain: System.get_env("FRESHBOOKS_API_SUBDOMAIN")

  # use Freshbooks.Client, otp_app: :freshbooks_api_client
  # Pass the caller into the interface...

  # https://www.freshbooks.com/developers/docs/clients#client.list
  def list_clients() do
    FreshbooksApiClient.Api.list(FreshbooksApiClient.Interface.Clients)
  end

  def get_client!(client_id) do
    FreshbooksApiClient.Api.get!(FreshbooksApiClient.Interface.Clients, [client_id: client_id])
  end

  # https://www.freshbooks.com/developers/docs/invoices#invoice.list
  def list_invoices(date: date) do
    date = Date.to_iso8601(date)
    FreshbooksApiClient.Api.list(FreshbooksApiClient.Interface.Invoices, [date_from: date, date_to: date])
  end

  def get_invoice!(invoice_id) do
    FreshbooksApiClient.Api.get!(FreshbooksApiClient.Interface.Invoices, [invoice_id: invoice_id])
  end

  # https://www.freshbooks.com/developers/docs/projects#project.list
  def list_projects() do
    FreshbooksApiClient.Api.list(FreshbooksApiClient.Interface.Projects)
  end

  def get_project!(project_id) do
    FreshbooksApiClient.Api.get!(FreshbooksApiClient.Interface.Projects, [project_id: project_id])
  end

  # https://www.freshbooks.com/developers/docs/staff#staff.list
  def list_staff() do
    FreshbooksApiClient.Api.list(FreshbooksApiClient.Interface.Staff)
  end

  def get_staff!(staff_id) do
    FreshbooksApiClient.Api.get!(FreshbooksApiClient.Interface.Staff, [staff_id: staff_id])
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
    FreshbooksApiClient.Api.get!(FreshbooksApiClient.Interface.Tasks, [task_id: task_id])
  end

  # https://www.freshbooks.com/developers/docs/time-entries#time_entry.list
  def list_time_entries(date: date) do
    date = Date.to_iso8601(date)
    FreshbooksApiClient.Api.list(FreshbooksApiClient.Interface.TimeEntries, [date_from: date, date_to: date])
  end

  def get_time_entry!(time_entry_id) do
    FreshbooksApiClient.Api.get!(FreshbooksApiClient.Interface.TimeEntries, [time_entry_id: time_entry_id])
  end

  # {:ok, TimeEntry%{}} | {:error, errors}
  # def create_time_entry(params) do
  #
  # end

  # {:ok, TimeEntry%{}} | {:error, errors}
  # def update_time_entry(time_entry, params) do

  # end

  # {:ok, time_entry} = FreshbooksApiClient.Interface.TimeEntries.update(caller, time_entry_id: 1578296, notes: "Another Test")
  # {:ok, time_entry} = FreshbooksApiClient.Interface.TimeEntries.update(caller, %{time_entry_id: 1578296}, notes: "Another Test")
  # {:ok, time_entry} = FreshbooksApiClient.Interface.TimeEntries.update(caller, time_entry, notes: "Another Test")

  # def delete_time_entry(time_entry) do
  #   {:ok, TimeEntry%{}} | {:error, errors}
  # end
end
