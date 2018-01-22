defmodule FreshbooksApiClient.Schema do
  @moduledoc """
  This module defines the behavior a `schema` must implement in order
  to be accessible through the native callers of this package.

  ## Callbacks:

  * resource() -> Returns a string cooresponding to resource name in
                  Freshbook's API response.
  """

  @callback resource() :: String.t()

  @doc ~S(Facebooks abstraction for an ecto embedded schema)
  defmacro api_schema(do: fields) do
    quote do
      import Ecto.Schema
      embedded_schema(do: unquote(fields))
    end
  end

  @doc ~S(A Simple way of accessing all Schema's features)
  defmacro __using__(opts) do
    resource = Keyword.get(opts, :resource)

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

      defoverridable [resource: 0]
    end
  end
end

