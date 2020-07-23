defmodule FreshbooksApiClient do
  @moduledoc """
  A Wrapper around [Freshbooks API](https://www.freshbooks.com/developers)

  This package is an extendable wrapper, so it will only let you see resources that
  correspond to permissions associated with the API token

  This package can be configured with default `token` and `subdomain`.
  This package can also be configured with a default `caller`. It should be used
  mainly for testing purposes.

  ## Example Configuration (dev.exs)(Optional):

      config :freshbooks_api_client, FreshbooksApiClient,
        caller: FreshbooksApiClient.Caller.HttpXml,
        token: "YOUR_FRESHBOOKS_API_TOKEN",
        subdomain: "sample"

  ## Example Configuration (test.exs)(Optional):

      config :freshbooks_api_client, FreshbooksApiClient,
        caller: FreshbooksApiClient.InMemory,
        token: "thuum",
        subdomain: "skyrim"

  """
end

defmodule FreshbooksApiClient.RateLimitError do
  defexception message: "the API responded with a 'rate-limited' error"
end

defmodule FreshbooksApiClient.PaginationError do
  defexception message: "the total_count changed while retrieving results"
end

defmodule FreshbooksApiClient.NoResultsError do
  defexception message: "No Results"
end
