defmodule FreshbooksApiClient.Caller.HttpXml do
  @moduledoc """
  This module makes a request using HTTP and XML.

  It uses FreshbooksApiClient.Caller
  """

  @base_url "https://:subdomain.freshbooks.com/api/2.1/xml-in"

  use FreshbooksApiClient.Caller

  alias FreshbooksApiClient.Xml

  def run([method: method, params: params], opts \\ []) do
    method
    |> get_request_body(params)
    |> make_request(opts)
  end

  def get_request_body(method, params) do
    Xml.to_xml(method, params)
  end

  def make_request(body, opts) do
    HTTPoison.post(request_url(), body, generate_headers())
  end

  def generate_headers() do
    [auth_headers()]
  end

  def content_headers() do
    {"Accept", "application/xml"}
  end

  def auth_headers() do
    encoded = Base.encode64("#{FreshbooksApiClient.token()}:X")
    {"Authorization", "Basic #{encoded}"}
  end

  def request_url(), do: request_url(FreshbooksApiClient.subdomain())
  def request_url(subdomain) do
    String.replace(@base_url, ":subdomain", subdomain)
  end
end
