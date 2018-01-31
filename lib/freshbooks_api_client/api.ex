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

    (prod.exs)
    config :freshbooks_api_client, FreshbooksApiClient.Api,
      caller: FreshbooksApiClient.Caller.HttpXml,
      load_from_system_env: true

    NOTE: In Production (with runtime configuration) you must call
    FreshbooksApiClient.Api.init() before using the client. A Supervisor is a
    great place to do that! For example:

    defmodule YourApplication.Supervisor do
      use Supervisor

      def start_link(opts) do
        Supervisor.start_link(__MODULE__, ..., opts)
      end

      def init(...) do
        FreshbooksApiClient.Api.init()

        children = [
          ...
        ]

        Supervisor.init(children, strategy: :one_for_one)
      end
    end

  # Usage:

    FreshbooksApiClient.Api.list(FreshbooksApiClient.Interface.Clients)
  """
  use FreshbooksApiClient.ApiBase, otp_app: :freshbooks_api_client

  def init(config) do
    if config[:load_from_system_env] do
      token = System.get_env("FRESHBOOKS_API_TOKEN") || raise "expected the FRESHBOOKS_API_TOKEN environment variable to be set"
      subdomain = System.get_env("FRESHBOOKS_API_SUBDOMAIN") || raise "expected the FRESHBOOKS_API_SUBDOMAIN environment variable to be set"

      config = config
      |> Keyword.put(:token, token)
      |> Keyword.put(:subdomain, subdomain)

      {:ok, config}
    else
      {:ok, config}
    end
  end
end
