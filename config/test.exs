use Mix.Config

config :exvcr, [
  vcr_cassette_library_dir: "test/fixture/vcr_cassettes",
  filter_request_headers: ["Authorization"]
]
