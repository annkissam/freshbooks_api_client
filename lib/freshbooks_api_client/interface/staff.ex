defmodule FreshbooksApiClient.Interface.Staff do
  @moduledoc """
  This module handles the interface operations to interact with Freshbooks
  staff resource.

  It uses a FreshbooksApiClient.Interface
  """

  import SweetXml

  alias FreshbooksApiClient.Schema.Staff

  use FreshbooksApiClient.Interface, schema: Staff, allow: ~w(get list)a

  def xml_parent_spec(:list) do
    {
      ~x"//response/staff_members/member"l,
      xml_spec()
    }
  end

  def xml_parent_spec(:get) do
    {
      ~x"//response/staff",
      xml_spec()
    }
  end

  def xml_spec do
    [
      staff_id: ~x"./staff_id/text()"i,
      username: ~x"./username/text()"s,
      first_name: ~x"./first_name/text()"s,
      last_name: ~x"./last_name/text()"s,
      email: ~x"./email/text()"s,
      business_phone: ~x"./business_phone/text()"s,
      mobile_phone: ~x"./mobile_phone/text()"s,
      rate: ~x"./rate/text()"s,
      last_login: ~x"./last_login/text()"s,
      number_of_logins: ~x"./number_of_logins/text()"Io,
      signup_date: ~x"./signup_date/text()"s,
      street1: ~x"./street1/text()"s,
      street2: ~x"./street2/text()"s,
      city: ~x"./city/text()"s,
      state: ~x"./state/text()"s,
      country: ~x"./country/text()"s,
      code: ~x"./code/text()"s,
    ]
  end

  # def translate(_, _, {:error, :unauthorized}), do: raise "Unauthorized!"
  # def translate(_, _, {:error, :conn}), do: raise "HTTP Connection Error!"
  # def translate(FreshbooksApiClient.Caller.HttpXml, :get, {:ok, xml}) do
  #   xml
  #   |> xpath(
  #     ~x"//response/#{apply(Staff, :resource, [])}",
  #     Staff
  #     |> apply(:__schema__, [:fields])
  #     |> Enum.map(&{&1, ~x"./#{&1}/text()"s}))
  #   |> to_schema()
  # end
  # # This is really weird for Staff Resource.
  # # This is super inconsistent and hopefully Freshbooks will change it in
  # # future.
  # def translate(FreshbooksApiClient.Caller.HttpXml, :list, {:ok, xml}) do
  #   xml
  #   |> xpath(
  #     ~x"//response/staff_members/member"l,
  #     Staff
  #     |> apply(:__schema__, [:fields])
  #     |> Enum.map(&{&1, ~x"./#{&1}/text()"s}))
  #   |> Enum.map(&to_schema/1)
  # end

  def transform(field, params) when field in [:rate] do
    Map.update!(params, field, fn curr ->
      case curr do
        "" -> nil
        _ ->
          curr
          |> Decimal.new
      end
    end)
  end

  def transform(field, params) when field in [:last_login, :signup_date] do
    Map.update!(params, field, fn curr ->
      case curr do
        "" -> nil
        _ -> NaiveDateTime.from_iso8601!(curr)
      end
    end)
  end

  def transform(_field, params), do: params
end
