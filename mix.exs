defmodule FreshbooksApiClient.Mixfile do
  use Mix.Project

  @version "0.4.0"
  @url "https://github.com/annkissam/freshbooks_api_client"

  def project do
    [
      app: :freshbooks_api_client,
      version: @version,
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      build_embedded: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),

      # Hex
      description: description(),
      package: package(),

      # Docs
      name: "Akd",
      docs: docs()
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  def application do
    [extra_applications: [:logger]]
  end

  defp description() do
    """
    A extendable wrapper around Freshbooks API written in Elixir.
    """
  end

  def package do
    [
      files: ["lib", "mix.exs", "README.md"],
      maintainers: ["Adi Iyengar", "Eric Sullivan"],
      licenses: ["MIT"],
      links: %{"Github" => @url}
    ]
  end

  def docs do
    [
      main: "FreshbooksApiClient",
      source_url: @url,
      source_ref: "v#{@version}"
    ]
  end

  defp deps do
    [
      {:ecto, "~> 3.0"},
      {:ex_doc, "~> 0.22", only: :dev, runtime: false},
      {:httpoison, "~> 1.7"},
      {:retry, "~> 0.14"},
      {:sweet_xml, "~> 0.6"},
      {:xml_builder, "~> 2.0"}
    ]
  end

  defp aliases do
    [publish: ["hex.publish", &git_tag/1]]
  end

  defp git_tag(_args) do
    System.cmd("git", ["tag", "v" <> Mix.Project.config()[:version]])
    System.cmd("git", ["push", "--tags"])
  end
end
