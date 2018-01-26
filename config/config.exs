use Mix.Config

config :freshbooks_api_client, FreshbooksApiClient,
  token: System.get_env("FRESHBOOKS_API_TOKEN"),
  subdomain: System.get_env("FRESHBOOKS_API_SUBDOMAIN")

if Mix.env == :test, do: import_config "#{Mix.env}.exs"
