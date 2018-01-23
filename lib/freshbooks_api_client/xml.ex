defmodule FreshbooksApiClient.Xml do
  @moduledoc """
  This module handles operations of converting params to XMLs and XMLs back
  to readble params
  """

  @base """
  <?xml version="1.0", encoding="utf-8"?>
  <request method=":method">
    <:resource>
      :fields
    </:resource>
  </request>
  """

  @field "<:field>:value</:field>"

  def to_xml(method, params) do
    resource = get_resource(method)
    get_xml_string(resource, method, Enum.to_list(params))
  end

  defp get_resource(method), do: method |> String.split(".") |> Enum.at(0)

  defp get_xml_string(resource, method, keyword) do
    fields = keyword
      |> Enum.reduce("", &accumulate_fields/2)
      |> String.trim("\n")

    @base
    |> String.replace(":resource", resource)
    |> String.replace(":method", method)
    |> String.replace(":fields", fields)
  end

  defp accumulate_fields(field, acc) do
    acc <> "\n" <> stringify_field(field)
  end

  def stringify_field({field_name, value}) do
    @field
    |> String.replace(":field", to_string(field_name))
    |> String.replace(":value", to_string(value))
  end
end
