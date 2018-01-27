defmodule FreshbooksApiClient.Interface.Clients do
  @moduledoc """
  This module handles the interface operations to interact with Freshbooks
  projects resource.

  It uses a FreshbooksApiClient.Interface
  """

  import SweetXml

  alias FreshbooksApiClient.Schema.Client

  use FreshbooksApiClient.Interface, schema: Client, allow: ~w(get list)a

  def xml_parent_spec(:list) do
    {
      ~x"//response/clients/client"l,
      xml_spec()
    }
  end

  def xml_parent_spec(:get) do
    {
      ~x"//response/client",
      xml_spec()
    }
  end

  def xml_spec do
    [
      client_id: ~x"./client_id/text()"i,
      first_name: ~x"./first_name/text()"s,
      last_name: ~x"./last_name/text()"s,
      organization: ~x"./organization/text()"s,
    ]
  end

end
