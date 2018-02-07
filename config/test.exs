use Mix.Config

config :freshbooks_api_client, FreshbooksApiClient.InMemoryApi,
  caller: FreshbooksApiClient.Caller.InMemory

config :exvcr, [
  vcr_cassette_library_dir: "test/fixture/vcr_cassettes",
  filter_request_headers: ["Authorization"]
]
