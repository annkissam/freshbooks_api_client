defmodule FreshbooksApiClient.Xml do
  @moduledoc """
  This module handles operations of converting params to XMLs and XMLs back
  to readble params
  """

  import XmlBuilder

  @posts ~w(create update)

  def to_xml(method, params) do
    {resource, method} = get_resource_and_method(method)
    get_xml_string(resource, method, Enum.to_list(params))
  end

  defp get_resource_and_method(method) do
    [resource, method] = String.split(method, ".")
    {resource, method}
  end

  defp get_xml_string(resource, method, keyword) when method in @posts do
    :request
    |> element(%{method: resource <> "." <> method},
               [element(resource, keyword)])
    |> doc()
  end
  defp get_xml_string(resource, method, keyword) do
    :request
    |> element(%{method: resource <> "." <> method}, keyword)
    |> doc()
  end
end
