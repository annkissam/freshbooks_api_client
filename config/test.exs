use Mix.Config

config :freshbooks_api_client, FreshbooksApiClient.InMemoryApi,
  caller: FreshbooksApiClient.Caller.InMemory
