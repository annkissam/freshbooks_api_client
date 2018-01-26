defmodule FreshbooksApiClient.Schema.Invoice do
  @moduledoc """
  This module handles metadata related to a Freshbooks Client.

  It uses a FreshbooksApiClient.Schema
  """

  use FreshbooksApiClient.Schema, resource: "invoice"

  api_schema do
    field :invoice_id, :integer
    field :date, :date
    field :amount, :decimal
    field :amount_outstanding, :decimal
    field :status, :string
    field :folder, :string

    belongs_to :client, FreshbooksApiClient.Schema.Client

    embeds_many :lines, FreshbooksApiClient.Schema.InvoiceLine
  end
end
