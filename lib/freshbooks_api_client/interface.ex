defmodule FreshbooksApiClient.Interface do
  @moduledoc """
  This module defines the behavior an `interface` must implement in order
  to be accessible through the native callers of this package.

  This module is at the heart of FreshbooksApiClient and catalyzes its
  extendability. This abstraction/behaviour provides a set of functions
  which can be included in a newly introduced Freshbooks resource and quickly
  integrated with the rest of the API client.

  See `FreshbooksApiClient.Interace.Tasks` for a simple example.
  See `FreshbooksApiClient.Interace.Staff` for a complex example.

  ## Callbacks:

  * create(params, caller) -> Creates the resource on Freshbooks.
  * update(params, caller) -> Updates an existing resource on Freshbooks.
  * get(params, caller) -> Retrieves an existing resource from Freshbooks.
  * delete(params, caller) -> Deletes an existing resource from Freshbooks.
  * list(params, caller) -> Retrieves a list of existing resources from Freshbooks.
  * translate(caller, action, response) -> Translates a response to a Schema struct.
  """

  # alias FreshbooksApiClient.Caller.{HttpXml, InMemory}

  import SweetXml

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
  @callback translate(atom(), atom(), term()) :: Ecto.Schema.t()

  @callback resource() :: String.t()
  @callback resources() :: String.t()

  @callback xml_parent_spec(atom()) :: {any, list}

  @doc ~S(A Simple way of accessing all of Interace's features)
  defmacro __using__(opts) do
    schema = Keyword.get(opts, :schema)
    allowed = Keyword.get(opts, :allow, @actions)
    resource = Keyword.get(opts, :resource)
    resources = Keyword.get(opts, :resources)

    quote do
      import SweetXml
      import FreshbooksApiClient.Parser

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
          nil -> resource() <> "s"
        end
      end

      defp schema() do
        case unquote(schema) do
          nil -> raise "schema/0 not implement for #{__MODULE__}"
          _ -> unquote(schema)
        end
      end

      def list(api, params \\ []) do
        caller = api.caller()
        case Enum.member?(unquote(allowed), :list) do
          true ->
            method = resource() <> ".list"
            translate(caller, :list, apply(caller, :run, [api, method, params]))
          _ -> raise "action `:list` not allowed for #{unquote(schema)}"
        end
      end

      def get(api, params) do
        caller = api.caller()
        case Enum.member?(unquote(allowed), :get) do
          true ->
            method = resource() <> ".get"
            translate(caller, :get, apply(caller, :run, [api, method, params]))
            _ -> raise "action `:get` not allowed for #{unquote(schema)}"
        end
      end

      def create(api, params) do
        caller = api.caller()
        case Enum.member?(unquote(allowed), :create) do
          true ->
            method = resource() <> ".create"
            translate(caller, :create, apply(caller, :run, [api, method, params]))
          _ -> raise "action `:create` not allowed for #{unquote(schema)}"
        end
      end

      def update(api, params) do
        caller = api.caller()
        case Enum.member?(unquote(allowed), :update) do
          true ->
            method = resource() <> ".update"
            translate(caller, :update, apply(caller, :run, [api, method, params]))
          _ -> raise "action `:update` not allowed for #{unquote(schema)}"
        end
      end

      def delete(api, params) do
        caller = api.caller()
        case Enum.member?(unquote(allowed), :delete) do
          true ->
            method = resource() <> ".delete"
            translate(caller, :delete, apply(caller, :run, [api, method, params]))
          _ -> raise "action `:delete` not allowed for #{unquote(schema)}"
        end
      end

      def translate(FreshbooksApiClient.Caller.HttpXml, method, {:fail, xml}) when method in [:create, :update, :get, :delete] do
        FreshbooksApiClient.Interface.translate(__MODULE__, unquote(schema), FreshbooksApiClient.Caller.HttpXml, method, {:fail, xml})
      end

      def translate(FreshbooksApiClient.Caller.HttpXml, method, {:fail, xml}) do
        raise "XML Error: #{xml}"
      end

      def translate(_, _, {:error, :unauthorized}), do: raise "Unauthorized!"

      def translate(_, _, {:error, :conn}), do: raise "HTTP Connection Error!"

      def translate(caller, method, {:ok, xml}) when method in [:create, :update, :delete, :get, :list] do
        FreshbooksApiClient.Interface.translate(__MODULE__, unquote(schema), caller, method, {:ok, xml})
      end

      def translate(caller, method, {return, _data}) do
        raise "translate/3 not implemented for #{__MODULE__} w/ (#{caller}, :#{method}, {:#{return}, data})"
      end

      defoverridable [{:resource, 0}, {:resources, 0}, {:translate, 3} | Enum.map(unquote(allowed), &{&1, 2})]
    end
  end

  # TODO: Does this capture all errors?
  def translate(_interface, _schema, FreshbooksApiClient.Caller.HttpXml, _method, {:fail, xml}) do
    parent = ~x"//response"
    spec = [
      error: ~x"./error/text()"s,
      code: ~x"./code/text()"i,
      field: ~x"./field/text()"os,
    ]

    errors = xml
    |> xpath(parent, spec)

    {:error, errors}
  end

  def translate(interface, schema, FreshbooksApiClient.Caller.HttpXml, :list, {:ok, xml}) do
    resources_key = apply(interface, :resources, [])
    per_page = xml |> xpath(~x"//response/#{resources_key}/@per_page"i)
    page = xml |> xpath(~x"//response/#{resources_key}/@page"i)
    pages = xml |> xpath(~x"//response/#{resources_key}/@pages"i)
    total = xml |> xpath(~x"//response/#{resources_key}/@total"i)

    {parent, spec} = apply(interface, :xml_parent_spec, [:list])

    resources = xml
      |> xpath(parent, spec)
      |> Enum.map(&(to_schema(schema, &1)))

    %{
      per_page: per_page,
      page: page,
      pages: pages,
      total: total,
      resources: resources,
    }
  end

  def translate(interface, schema, FreshbooksApiClient.Caller.HttpXml, :get, {:ok, xml}) do
    {parent, spec} = apply(interface, :xml_parent_spec, [:get])

    params = xml
    |> xpath(parent, spec)

    {:ok, to_schema(schema, params)}
  end

  def translate(interface, _schema, FreshbooksApiClient.Caller.HttpXml, :create, {:ok, xml}) do
    {parent, spec} = apply(interface, :xml_parent_spec, [:create])

    params = xml
    |> xpath(parent, spec)

    {:ok, params}
  end

  def translate(_interface, _schema, FreshbooksApiClient.Caller.HttpXml, :update, {:ok, _xml}) do
    {:ok, nil}
  end

  def translate(_interface, _schema, FreshbooksApiClient.Caller.HttpXml, :delete, {:ok, _xml}) do
    {:ok, nil}
  end

  def to_schema(schema, params) do
    struct!(schema, params)
  end
end
