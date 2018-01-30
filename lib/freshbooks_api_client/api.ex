defmodule FreshbooksApiClient.Api do
  @moduledoc """

  This is an Example API (that can also be used to get started). If you have a
  need for multiple API credentials, you can create one API module per domain.

  See the FreshbooksApiClient.ApiBase for available methods.

  # Configuration:

    config :freshbooks_api_client, FreshbooksApiClient.Api,
      caller: FreshbooksApiClient.Caller.HttpXml,
      token: System.get_env("FRESHBOOKS_API_TOKEN"),
      subdomain: System.get_env("FRESHBOOKS_API_SUBDOMAIN")

  # Usage:

    FreshbooksApiClient.Api.list(FreshbooksApiClient.Interface.Clients)
  """
  use FreshbooksApiClient.ApiBase, otp_app: :freshbooks_api_client
end
