defmodule FreshbooksApiClient.Interface do
  @moduledoc """
  This module defines the behavior an `interface` must implement in order
  to be accessible through the native callers of this package.

  ## Callbacks:

  * create(params, caller) -> Creates the resource on Freshbooks.
  * update(params, caller) -> Updates an existing resource on Freshbooks.
  * get(params, caller) -> Retrieves an existing resource from Freshbooks.
  * delete(params, caller) -> Deletes an existing resource from Freshbooks.
  * list(params, caller) -> Retrieves a list of existing resources from Freshbooks.
  * translate(caller, action, response) -> Translates a response to a Schema struct.
  """

  alias FreshbooksApiClient.Caller.{HttpXml, InMemory}

  @actions ~w(create update get delete list)a

  @typedoc ~S(Types that denote a successful response)
  @type success :: Ecto.Schema.t()

  @typedoc ~S(Types that denote an unsuccessful response)
  @type failure :: HTTPoison.Error.t() | String.t()

  @typedoc ~S(Various response types that can happen upon an interface call)
  @type response :: {:ok, success()} | {:error, failure()}

  @callback create(map, atom()) :: response()
  @callback update(map, atom()) :: response()
  @callback get(map, atom()) :: response()
  @callback delete(map, atom()) :: response()
  @callback list(map, atom()) :: response()

  @doc ~S(A Simple way of accessing all of Interace's features)
  defmacro __using__(opts) do
    schema = Keyword.get(opts, :schema)
    allowed = Keyword.get(opts, :allow, @actions)

    quote do
      import SweetXml

      @behaviour unquote(__MODULE__)

      defp schema() do
        case unquote(schema) do
          nil -> raise "resource/0 not implement for #{__MODULE__}"
          _ -> unquote(schema)
        end
      end

      def create(params, caller \\ FreshbooksApiClient.Caller.HttpXml) do
        case Enum.member?(unquote(allowed), :create) do
          true ->
            method = apply(unquote(schema), :resource, []) <> ".create"
            apply(caller, :run, [method, params])
            translate(caller, :create, apply(caller, :run, [method, params]))
          _ -> raise "action `:create` not allowed for #{unquote(schema)}"
        end
      end

      def update(params, caller \\ FreshbooksApiClient.Caller.HttpXml) do
        case Enum.member?(unquote(allowed), :update) do
          true ->
            method = apply(unquote(schema), :resource, []) <> ".update"
            translate(caller, :update, apply(caller, :run, [method, params]))
          _ -> raise "action `:update` not allowed for #{unquote(schema)}"
        end
      end

      def get(params, caller \\ FreshbooksApiClient.Caller.HttpXml) do
        case Enum.member?(unquote(allowed), :get) do
          true ->
            method = apply(unquote(schema), :resource, []) <> ".get"
            translate(caller, :get, apply(caller, :run, [method, params]))
            _ -> raise "action `:get` not allowed for #{unquote(schema)}"
        end
      end

      def delete(params, caller \\ FreshbooksApiClient.Caller.HttpXml) do
        case Enum.member?(unquote(allowed), :delete) do
          true ->
            method = apply(unquote(schema), :resource, []) <> ".delete"
            translate(caller, :delete, apply(caller, :run, [method, params]))
          _ -> raise "action `:delete` not allowed for #{unquote(schema)}"
        end
      end

      def list(params, caller \\ FreshbooksApiClient.Caller.HttpXml) do
        case Enum.member?(unquote(allowed), :list) do
          true ->
            method = apply(unquote(schema), :resource, []) <> ".list"
            translate(caller, :list, apply(caller, :run, [method, params]))
          _ -> raise "action `:list` not allowed for #{unquote(schema)}"
        end
      end

      def translate(_, _, {:error, :unauthorized}), do: raise "Unauthorized!"
      def translate(_, _, {:error, :conn}), do: raise "HTTP Connection Error!"
      def translate(FreshbooksApiClient.Caller.HttpXml, :get, {:ok, xml}) do
        xml
        |> xpath(
          ~x"//response/#{apply(unquote(schema), :resource, [])}",
          unquote(schema)
          |> apply(:__schema__, [:fields])
          |> Enum.map(&{&1, ~x"./#{&1}/text()"s}))
      end
      def translate(FreshbooksApiClient.Caller.HttpXml, :list, {:ok, xml}) do
        xml
        |> xpath(
          ~x"//response/#{apply(unquote(schema), :resources, [])}/#{apply(unquote(schema), :resource, [])}"l,
          unquote(schema)
          |> apply(:__schema__, [:fields])
          |> Enum.map(&{&1, ~x"./#{&1}/text()"s}))
        |> Enum.map(&to_schema/1)
      end
      def translate(_, _, _) do
        raise "translate/3 not implemented for #{__MODULE__}"
      end

      defp to_schema(params) do
        castable_params = unquote(schema)
          |> apply(:__schema__, [:fields])
          |> Enum.reduce(params, &transform/2)

        struct!(unquote(schema), castable_params)
      end

      defp transform(_field, params), do: params

      defoverridable [{:translate, 3}, {:transform, 2}
                      | Enum.map(unquote(allowed), &{&1, 2})]
    end
  end
end

