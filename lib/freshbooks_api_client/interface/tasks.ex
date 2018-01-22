defmodule FreshbooksApiClient.Interface.Tasks do
  @moduledoc """
  This module handles the interface operations to interact with Freshbooks
  tasks resource.

  It uses a FreshbooksApiClient.Interface
  """

  alias FreshbooksApiClient.Schema.Task

  use FreshbooksApiClient.Interface, schema: Task

  def create(params) do

  end
end
