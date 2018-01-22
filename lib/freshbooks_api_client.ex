defmodule FreshbooksApiClient do
  @moduledoc """
  A Wrapper around [Freshbooks API](https://www.freshbooks.com/developers)

  This package is just a wrapper, so it will only let you see resources that
  correspond to permissions associated with the API token

  This package can be configured with default `token` and `subdomain`.
  This package can also be configured with a default `caller`. It should be used
  mainly for testing purposes.

  ## Example Configuration (dev.exs)(Optional):

      config :freshbooks_api_client, FreshbooksApiClient,
        caller: FreshbooksApiClient.HTTPClient,
        token: "YOUR_FRESHBOOKS_API_TOKEN",
        subdomain: "sample"

  ## Example Configuration (test.exs)(Optional):

      config :freshbooks_api_client, FreshbooksApiClient,
        caller: FreshbooksApiClient.InMemory,
        token: "thuum",
        subdomain: "skyrim"

  """

  @doc """
  `:caller` can be set as a runtime config
  in the `config.exs` file

  ## Examples
  when no `caller` config is set, if returns `FreshbooksApiClient.Caller`
      iex> FreshbooksApiClient.caller
      FreshbooksApiClient.InMemory
  """
  def caller do
    config(:caller, FreshbooksApiClient.HTTPClient)
  end


  @doc """
  `:token` can be set as a runtime config
  in the `config.exs` file

  ## Examples
  when no `token` config is set, if returns nil
      iex> FreshbooksApiClient.token
      "thuum"
  """
  def token do
    config(:token, nil)
  end


  @doc """
  `:subdomain` can be set as a runtime config
  in the `config.exs` file

  ## Examples
  when no `subdomain` config is set, if returns nil
      iex> FreshbooksApiClient.subdomain
      "skyrim"
  """
  def subdomain do
    config(:subdomain, nil)
  end


  @doc """
  Gets configuration assocaited with the `freshbooks_api_client` app.

  ## Examples
  when no config is set, if returns []
      iex> FreshbooksApiClient.config
      [caller: FreshbooksApiClient.InMemory, token: "thuum", subdomain: "skyrim"]
  """
  def config do
    Application.get_env(:freshbooks_api_client, FreshbooksApiClient, [])
  end


  @doc """
  Gets configuration set for a `key`, assocaited with the `freshbooks_api_client` app.

  ## Examples
  when no config is set for `key`, if returns `default`
      iex> FreshbooksApiClient.config(:random, "default")
      "default"
  """
  def config(key, default \\ nil) do
    config()
    |> Keyword.get(key, default)
    |> resolve_config(default)
  end

  def resolve_config(value, _default), do: value
end
