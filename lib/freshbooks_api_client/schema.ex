defmodule FreshbooksApiClient.Schema do
  @moduledoc """
  This module defines the behavior a `schema` must implement in order
  to be accessible through the native callers of this package.

  ## Callbacks:

  * resource_url(opts) -> Returns a sub-url associated with the Schema.
  * collection_name() -> Returns a string cooresponding to collection name in
                         Freshbook's API response.
  """

  @callback resource_url(Keyword.t() :: map) :: String.t()
  @callback collection_name() :: String.t()

  defmacro __using__(opts) do
    collection_name = Keyword.get(opts, :collection_name)

    quote do
      def resource_url(_, _) do
        raise "resource_url/2 not implemented for #{__MODULE__}"
      end

      def collection_name() do
        case unquote(collection_name) do
          n when is_binary(n) -> n
          nil -> raise "collection_name/0 not implement for #{__MODULE__}"
          _ -> raise "collection_name given isn't a string for #{__MODULE__}"
        end
      end

      defoverridable [resource_url: 2, collection_name: 0]
    end
  end
end

