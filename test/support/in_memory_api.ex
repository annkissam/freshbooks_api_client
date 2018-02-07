defmodule FreshbooksApiClient.InMemoryApi do
  use FreshbooksApiClient.ApiBase, otp_app: :freshbooks_api_client

  def stub_request("time_entry.list", []) do
    %{
      per_page: 25,
      page: 1,
      pages: 1,
      total: 2,
      resources: [
        time_entry_1(),
        time_entry_2(),
      ],
    }
  end

  defp time_entry_1 do
    %FreshbooksApiClient.Schema.TimeEntry{
      time_entry_id: 100,
      hours: Decimal.new(8),
      date: ~D[2018-01-01],
      notes: "New Years",
      billed: false,
      staff_id: 50,
      project_id: 40,
      task_id: 60,
    }
  end

  defp time_entry_2 do
    %FreshbooksApiClient.Schema.TimeEntry{
      time_entry_id: 101,
      hours: Decimal.new(8),
      date: ~D[2018-01-01],
      notes: "New Years Day",
      billed: false,
      staff_id: 51,
      project_id: 41,
      task_id: 61,
    }
  end
end
