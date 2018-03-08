defmodule FreshbooksApiClient.Interface.Invoices do
  @moduledoc """
  This module handles the interface operations to interact with Freshbooks
  projects resource.

  It uses a FreshbooksApiClient.Interface
  """

  use FreshbooksApiClient.Interface,
    schema: FreshbooksApiClient.Schema.Invoice,
    resources: "invoices",
    resource: "invoice",
    allow: ~w(get list)a

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
      invoice_id: ~x"./invoice_id/text()"i,
      date: ~x"./date/text()"s |> transform_by(&parse_date/1),
      amount: ~x"./amount/text()"s |> transform_by(&parse_decimal/1),
      amount_outstanding: ~x"./amount_outstanding/text()"s |> transform_by(&parse_decimal/1),
      status: ~x"./status/text()"s,
      folder: ~x"./folder/text()"s,
      number: ~x"./number/text()"s,
      notes: ~x"./notes/text()"s,
      client_id: ~x"./client_id/text()"i,
      lines: ~x"./lines/line"l |> transform_by(&parse_lines/1),
    ]
  end

  def parse_lines(xmls) do
    Enum.map(xmls, fn(xml) ->
      xmap(xml,
        line_id: ~x"./line_id/text()"i,
        order: ~x"./order/text()"i,
        name: ~x"./name/text()"s,
        description: ~x"./description/text()"s,
        unit_cost: ~x"./unit_cost/text()"s |> transform_by(&parse_decimal/1),
        quantity: ~x"./quantity/text()"s |> transform_by(&parse_decimal/1),
        amount: ~x"./amount/text()"s |> transform_by(&parse_decimal/1),
        type: ~x"./type/text()"s
      )
    end)
  end

end
