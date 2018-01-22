defmodule FreshbooksApiClient.Mixfile do
  use Mix.Project

  def project do
    [
      app: :freshbooks_api_client,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ecto, "~> 2.2"},
      {:httpoison, "~> 0.13"},
    ]
  end
end
