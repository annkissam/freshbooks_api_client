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
    FreshbooksApiClient.Interface.all(FreshbooksApiClient.Interface.Clients)
  end

  def get_client(client_id) do
    FreshbooksApiClient.Interface.call(FreshbooksApiClient.Interface.Clients, :get, [client_id: client_id])
  end

  # https://www.freshbooks.com/developers/docs/invoices#invoice.list
  def list_invoices(date: date) do
    date = Date.to_iso8601(date)
    FreshbooksApiClient.Interface.all(FreshbooksApiClient.Interface.Invoices, [date_from: date, date_to: date])
  end

  def get_invoice(invoice_id) do
    FreshbooksApiClient.Interface.call(FreshbooksApiClient.Interface.Invoices, :get, [invoice_id: invoice_id])
  end

  # https://www.freshbooks.com/developers/docs/projects#project.list
  def list_projects() do
    FreshbooksApiClient.Interface.all(FreshbooksApiClient.Interface.Projects)
  end

  def get_project(project_id) do
    FreshbooksApiClient.Interface.call(FreshbooksApiClient.Interface.Projects, :get, [project_id: project_id])
  end

  # https://www.freshbooks.com/developers/docs/staff#staff.list
  def list_staff() do
    FreshbooksApiClient.Interface.all(FreshbooksApiClient.Interface.Staff)
  end

  def get_staff(staff_id) do
    FreshbooksApiClient.Interface.call(FreshbooksApiClient.Interface.Staff, :get, [staff_id: staff_id])
  end

  # https://www.freshbooks.com/developers/docs/tasks#task.list
  def list_tasks() do
    FreshbooksApiClient.Interface.all(FreshbooksApiClient.Interface.Tasks)
  end

  def get_task(task_id) do
    FreshbooksApiClient.Interface.call(FreshbooksApiClient.Interface.Tasks, :get, [task_id: task_id])
  end

  # https://www.freshbooks.com/developers/docs/time-entries#time_entry.list
  def list_time_entries(date: date) do
    date = Date.to_iso8601(date)
    FreshbooksApiClient.Interface.all(FreshbooksApiClient.Interface.TimeEntries, [date_from: date, date_to: date])
  end

  def get_time_entry(time_entry_id) do
    FreshbooksApiClient.Interface.call(FreshbooksApiClient.Interface.TimeEntries, :get, [time_entry_id: time_entry_id])
  end
end
