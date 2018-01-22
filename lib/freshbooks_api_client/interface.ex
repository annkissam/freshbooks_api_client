defmodule FreshbooksApiClient.Interface do
  @moduledoc """
  This module defines the behavior an `interface` must implement in order
  to be accessible through the native callers of this package.

  ## Callbacks:

  * create(params) -> Creates the resource on Freshbooks.
  * update(params) -> Updates an existing resource on Freshbooks.
  * get(params) -> Retrieves an existing resource from Freshbooks.
  * delete(params) -> Deletes an existing resource from Freshbooks.
  * list(params) -> Retrieves a list of existing resources from Freshbooks.
  """

  @typedoc ~S(Types that denote a successful response)
  @type success :: HTTPoison.Response.t()

  @typedoc ~S(Types that denote an unsuccessful response)
  @type failure :: HTTPoison.Error.t() | String.t()

  @typedoc ~S(Various response types that can happen upon an interface call)
  @type response :: {:ok, success()} | {:error, failure()}

  @callback create(map) :: response()
  @callback update(map) :: response()
  @callback get(map) :: response()
  @callback delete(map) :: response()
  @callback list(map) :: response()

  @doc ~S(A Simple way of accessing all Schema's features)
  defmacro __using__(opts) do
    schema = Keyword.get(opts, :schema)

    quote do
      use Ecto.Schema
      import unquote(__MODULE__)

      @behaviour unquote(__MODULE__)

      defp schema() do
        case unquote(schema) do
          nil -> raise "resource/0 not implement for #{__MODULE__}"
          _ -> unquote(schema)
        end
      end
    end
  end
end

