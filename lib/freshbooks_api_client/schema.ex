defmodule FreshbooksApiClient.Schema do
  @moduledoc """
  This module defines the behavior a `schema` must implement in order
  to be accessible through the native callers of this package.

  This module adds extendability to this package. By using this module
  and defining certain callbacks, a new set of resource can be very easily
  integrated with this API client.

  See `FreshbooksApiClient.Schema.Task` for an example of a simple `Schema`.
  See `FreshbooksApiClient.Schema.Project` for an example of a complex `Schema`.

  ## Callbacks:

  * resource() -> Returns a string cooresponding to resource name in
                  Freshbook's API response.
  * resources() -> Returns a string cooresponding to resource collection in
                  Freshbook's API response.
  """

  @callback resource() :: String.t()
  @callback resources() :: String.t()

  @doc ~S(Facebooks abstraction for an ecto embedded schema)
  defmacro api_schema(do: fields) do
    quote do
      import Ecto.Schema
      @primary_key false
      embedded_schema(do: unquote(fields))
    end
  end

  @doc ~S(A Simple way of accessing all Schema's features)
  defmacro __using__(opts) do
    resource = Keyword.get(opts, :resource)
    resources = Keyword.get(opts, :resources)

    quote do
      use Ecto.Schema

      import unquote(__MODULE__)

      @behaviour unquote(__MODULE__)

      def resource() do
        case unquote(resource) do
          n when is_binary(n) -> n
          nil -> raise "resource/0 not implement for #{__MODULE__}"
          _ -> raise "resource given isn't a string for #{__MODULE__}"
        end
      end

      def resources() do
        case unquote(resources) do
          n when is_binary(n) -> n
          nil -> resource <> "s"
        end
      end

      defoverridable [resource: 0, resources: 0]
    end
  end
end

