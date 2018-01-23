defmodule FreshbooksApiClient.Schema.Staff do
  @moduledoc """
  This module handles metadata related to a Freshbooks Staff.

  It uses a FreshbooksApiClient.Schema
  """

  use FreshbooksApiClient.Schema, resource: "staff"

  api_schema do
    field :staff_id, :integer
    field :username, :string
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :business_phone, :string
    field :mobile_phone, :string
    field :rate, :float
    field :last_login, :utc_datetime
    field :number_of_logins, :integer
    field :signup_date, :utc_datetime
    field :street1, :string
    field :street2, :string
    field :city, :string
    field :state, :string
    field :country, :string
    field :code, :string
  end
end