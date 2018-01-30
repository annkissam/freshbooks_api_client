defmodule FreshbooksApiClient.Caller.HttpXml do
  @moduledoc """
  This module makes a request using HTTP and XML.

  It uses FreshbooksApiClient.Caller
  """

  @base_url "https://:subdomain.freshbooks.com/api/2.1/xml-in"

  use FreshbooksApiClient.Caller

  import SweetXml

  alias FreshbooksApiClient.Xml

  def run(api, method, params, opts \\ []) do
    response = method
      |> get_request_body(params)
      |> make_request(opts, api)

    case response do
      {:ok, %HTTPoison.Response{body: resp, status_code: 200}} ->
        status = resp |> xpath(~x"//response/@status"s)
        # https://www.freshbooks.com/developers
        # A successful call returns a status of "ok"
        # An unsuccessful call returns a status of "fail"
        {String.to_atom(status), resp}
      {:ok, %HTTPoison.Response{body: _resp, status_code: 429}} ->
        # https://www.freshbooks.com/developers - Request Limits
        raise FreshbooksApiClient.RateLimitError
      {:ok, %HTTPoison.Response{body: _resp, status_code: 401}} ->
        {:error, :unauthorized}
      {:ok, %HTTPoison.Error{reason: _}} -> {:error, :conn}
    end
  end

  defp get_request_body(method, params) do
    Xml.to_xml(method, params)
  end

  defp make_request(body, _opts, api) do
    HTTPoison.post(request_url(api), body, generate_headers(api))
  end

  defp generate_headers(api) do
    [auth_headers(api)]
  end

  # defp content_headers() do
  #   {"Accept", "application/xml"}
  # end

  defp auth_headers(api) do
    token = api.token()
    encoded = Base.encode64("#{token}:X")
    {"Authorization", "Basic #{encoded}"}
  end

  defp request_url(api) do
    subdomain = api.subdomain()
    String.replace(@base_url, ":subdomain", subdomain)
  end
end
