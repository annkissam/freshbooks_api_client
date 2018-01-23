use Mix.Config

config :freshbooks_api_client, FreshbooksApiClient,
  token: System.get_env("FRESHBOOKS_API_TOKEN"),
  subdomain: "annkissamllc"
