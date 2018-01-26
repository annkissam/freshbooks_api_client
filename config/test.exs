use Mix.Config

# config :freshbooks_api_client, FreshbooksApiClient,
#   token: "thuum",
#   subdomain: "skyrim"

config :exvcr, [
  vcr_cassette_library_dir: "test/fixture/vcr_cassettes",
  filter_request_headers: ["Authorization"]
]
