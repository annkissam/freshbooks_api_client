defmodule FreshbooksApiClient.Schema.Invoice do
  @moduledoc """
  This module handles metadata related to a Freshbooks Client.

  It uses a FreshbooksApiClient.Schema
  """

  use FreshbooksApiClient.Schema

  api_schema do
    field :invoice_id, :integer
    field :date, :date
    field :amount, :decimal
    field :amount_outstanding, :decimal
    field :status, :string
    field :folder, :string
    field :number, :string
    field :notes, :string

    belongs_to :client, FreshbooksApiClient.Schema.Client, references: :client_id

    embeds_many :lines, FreshbooksApiClient.Schema.InvoiceLine
  end

  def changeset(invoice, attrs) do
    invoice
    |> cast(attrs, [:invoice_id, :date, :amount, :amount_outstanding, :status, :folder, :number, :notes, :client_id])
    |> cast_embed(:lines)
  end
end
