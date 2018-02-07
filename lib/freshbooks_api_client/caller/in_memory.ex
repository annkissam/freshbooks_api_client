defmodule FreshbooksApiClient.Caller.InMemory do
  @moduledoc """
  This module stubs HTTP calls.

  Your API must implement stub_request/2

  For an example, see: FreshbooksApiClient.InMemoryApi
  """

  use FreshbooksApiClient.Caller

  def run(api, method, params, _opts \\ []) do
    api.stub_request(method, params)
  end
end
