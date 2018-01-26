defmodule FreshbooksApiClient.Interface.Invoices do
  @moduledoc """
  This module handles the interface operations to interact with Freshbooks
  projects resource.

  It uses a FreshbooksApiClient.Interface
  """

  import SweetXml

  alias FreshbooksApiClient.Schema.Invoice

  use FreshbooksApiClient.Interface, schema: Invoice, allow: ~w(get list)a

  def xml_parent_spec(:list) do
    {
     ~x"//response/invoices/invoice"l,
      xml_spec()
    }
  end

  def xml_parent_spec(:get) do
    {
      ~x"//response/invoice",
      xml_spec()
    }
  end

  def xml_spec do
    [
      invoice_id: ~x"./invoice_id/text()"s,
      date: ~x"./date/text()"s,
      amount: ~x"./amount/text()"s,
      amount_outstanding: ~x"./amount_outstanding/text()"s,
      status: ~x"./status/text()"s,
      folder: ~x"./folder/text()"s,
      client_id: ~x"./client_id/text()"s,
      lines: [~x"./lines/line"l,
        line_id: ~x"./line_id/text()"i,
        order: ~x"./order/text()"i,
        name: ~x"./name/text()"s,
        description: ~x"./description/text()"s,
        unit_cost: ~x"./unit_cost/text()"s,
        quantity: ~x"./quantity/text()"s,
        amount: ~x"./amount/text()"s,
        type: ~x"./type/text()"s,
      ],
    ]
  end

  def transform(field, params) when field in [:invoice_id, :client_id] do
    Map.update!(params, field, fn curr ->
      case curr do
        "" -> nil
        _ -> String.to_integer(curr)
      end
    end)
  end

  def transform(field, params) when field in [:date] do
    Map.update!(params, field, fn curr ->
      case curr do
        "" -> nil
        _ ->
          # Some date's also have a time component: 2018-01-01 00:00:00
          String.split(curr, " ")
          |> List.first
          |> Date.from_iso8601!
      end
    end)
  end

  def transform(field, params) when field in [:amount, :amount_outstanding] do
    Map.update!(params, field, fn curr ->
      case curr do
        "" -> nil
        _ ->
          curr
          |> Decimal.new
      end
    end)
  end

  def transform(:lines, params) do
    Map.update!(params, :lines, fn curr ->
      Enum.map(curr, &(to_schema(:line_item, &1)))
    end)
  end

  def to_schema(:line_item, params) do
    castable_params = FreshbooksApiClient.Schema.InvoiceLine
      |> apply(:__schema__, [:fields])
      |> Enum.reduce(params, &(transform(:invoice_line, &1, &2)))

    struct!(FreshbooksApiClient.Schema.InvoiceLine, castable_params)
  end

  def transform(_field, params), do: params

  def transform(:invoice_line, field, params) when field in [:unit_cost, :quantity, :amount] do
    Map.update!(params, field, fn curr ->
      case curr do
        "" -> nil
        _ ->
          curr
          |> Decimal.new
      end
    end)
  end

  def transform(:invoice_line, _field, params), do: params
end
