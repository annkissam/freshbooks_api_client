defmodule FreshbooksApiClient.Schema.Client do
  @moduledoc """
  This module handles metadata related to a Freshbooks Client.

  It uses a FreshbooksApiClient.Schema
  """

  use FreshbooksApiClient.Schema

  api_schema do
    field :client_id, :integer
    field :first_name, :string
    field :last_name, :string
    field :organization, :string
  end
end
