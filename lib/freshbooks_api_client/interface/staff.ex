defmodule FreshbooksApiClient.Interface.Staff do
  @moduledoc """
  This module handles the interface operations to interact with Freshbooks
  staff resource.

  It uses a FreshbooksApiClient.Interface
  """

  use FreshbooksApiClient.Interface,
    schema: FreshbooksApiClient.Schema.Staff,
    resources: "staff_members",
    resource: "staff",
    allow: ~w(get list)a

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
      rate: ~x"./rate/text()"s |> transform_by(&parse_decimal/1),
      last_login: ~x"./last_login/text()"s |> transform_by(&parse_datetime/1),
      number_of_logins: ~x"./number_of_logins/text()"Io,
      signup_date: ~x"./signup_date/text()"s |> transform_by(&parse_datetime/1),
      street1: ~x"./street1/text()"s,
      street2: ~x"./street2/text()"s,
      city: ~x"./city/text()"s,
      state: ~x"./state/text()"s,
      country: ~x"./country/text()"s,
      code: ~x"./code/text()"s
    ]
  end
end
