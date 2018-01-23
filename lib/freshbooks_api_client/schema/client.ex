defmodule FreshbooksApiClient.Schema.Client do
  @moduledoc """
  This module handles metadata related to a Freshbooks Client.

  It uses a FreshbooksApiClient.Schema
  """

  use FreshbooksApiClient.Schema, resource: "client"

  api_schema do
    field :client_id, :integer
    field :first_name, :string
    field :last_name, :string
    field :organization, :string
    # TODO: Add rest of the fields
    # For now, I'm adding only a few fields
  end
end
