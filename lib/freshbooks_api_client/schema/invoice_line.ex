defmodule FreshbooksApiClient.Schema.InvoiceLine do
  @moduledoc """
  This module handles metadata related to a Freshbooks Client.

  It uses a FreshbooksApiClient.Schema
  """

  use FreshbooksApiClient.Schema

  api_schema do
    field :line_id, :integer
    field :order, :integer
    field :name, :string
    field :description, :string
    field :unit_cost, :decimal
    field :quantity, :decimal
    field :amount, :decimal
    field :type, :string
  end
end
