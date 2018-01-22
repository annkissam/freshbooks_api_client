defmodule FreshbooksApiClient.Schema do
  @moduledoc """
  This module defines the behavior a `schema` must implement in order
  to be accessible through the native callers of this package.

  ## Callbacks:

  * resource_url(opts) -> Returns a sub-url associated with the Schema.
  * resource() -> Returns a string cooresponding to resource name in
                  Freshbook's API response.
  """

  @callback resource_url(Keyword.t() :: map) :: String.t()
  @callback resource() :: String.t()

  defmacro __using__(opts) do
    resource = Keyword.get(opts, :resource)

    quote do
      use Ecto.Schema

      def resource_url(_, _) do
        raise "resource_url/2 not implemented for #{__MODULE__}"
      end

      def resource() do
        case unquote(resource) do
          n when is_binary(n) -> n
          nil -> raise "resource/0 not implement for #{__MODULE__}"
          _ -> raise "resource given isn't a string for #{__MODULE__}"
        end
      end

      defoverridable [resource_url: 2, resource: 0]
    end
  end
end

