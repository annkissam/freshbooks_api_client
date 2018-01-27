defmodule FreshbooksApiClient.Schema do
  @moduledoc """
  This module defines the behavior a `schema` must implement in order
  to be accessible through the native callers of this package.

  This module adds extendability to this package. By using this module
  and defining certain callbacks, a new set of resource can be very easily
  integrated with this API client.
  """

  @doc ~S(Facebooks abstraction for an ecto embedded schema)
  defmacro api_schema(do: fields) do
    quote do
      @primary_key false
      embedded_schema(do: unquote(fields))
    end
  end

  @doc ~S(A Simple way of accessing all Schema's features)
  defmacro __using__(opts) do
    quote do
      use Ecto.Schema

      import FreshbooksApiClient.Schema
    end
  end
end

