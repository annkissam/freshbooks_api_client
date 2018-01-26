defmodule FreshbooksApiClient.Mixfile do
  use Mix.Project

  @version "0.1.0"
  @url "https://github.com/aditya7iyengar/freshbooks_api_client"

  def project do
    [
      app: :freshbooks_api_client,
      version: @version,
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      build_embedded: Mix.env == :prod,
      deps: deps(),
      aliases: aliases(),

      # Hex
      description: description(),
      package: package(),

      # Docs
      name: "Akd",
      docs: docs(),
    ]
  end

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
      maintainers: ["Adi Iyengar"],
      licenses: ["MIT"],
      links: %{"Github" => @url},
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
      {:ecto, "~> 2.2"},
      {:ex_doc, "~> 0.14", only: :dev, runtime: false},
      {:exvcr, "~> 0.8", only: :test},
      {:httpoison, "~> 0.13"},
      {:poison, "~> 3.1"},
      {:retry, "~> 0.8"},
      {:sweet_xml, "~> 0.6"},
      {:xml_builder, "~> 2.0"},
    ]
  end

  defp aliases do
    ["publish": ["hex.publish", &git_tag/1]]
  end

  defp git_tag(_args) do
    System.cmd "git", ["tag", "v" <> Mix.Project.config[:version]]
    System.cmd "git", ["push", "--tags"]
  end
end
