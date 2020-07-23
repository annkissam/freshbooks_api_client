defmodule FreshbooksApiClient.Schema.Staff do
  @moduledoc """
  This module handles metadata related to a Freshbooks Staff.

  It uses a FreshbooksApiClient.Schema
  """

  use FreshbooksApiClient.Schema

  api_schema do
    field(:staff_id, :integer)
    field(:username, :string)
    field(:first_name, :string)
    field(:last_name, :string)
    field(:email, :string)
    field(:business_phone, :string)
    field(:mobile_phone, :string)
    field(:rate, :decimal)
    field(:last_login, :naive_datetime)
    field(:number_of_logins, :integer)
    field(:signup_date, :naive_datetime)
    field(:street1, :string)
    field(:street2, :string)
    field(:city, :string)
    field(:state, :string)
    field(:country, :string)
    field(:code, :string)
  end

  def changeset(staff, attrs) do
    staff
    |> cast(attrs, [
      :staff_id,
      :username,
      :first_name,
      :last_name,
      :email,
      :business_phone,
      :mobile_phone,
      :rate,
      :last_login,
      :number_of_logins,
      :signup_date,
      :street1,
      :street2,
      :city,
      :state,
      :country,
      :code
    ])
  end
end
