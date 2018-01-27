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
  * to_schema(params) -> Converts the params to the specified schema struct.
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
  @callback to_schema(map()) :: Ecto.Schema.t()

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

      def create(params, caller \\ FreshbooksApiClient.Caller.HttpXml) do
        case Enum.member?(unquote(allowed), :create) do
          true ->
            method = resource() <> ".create"
            apply(caller, :run, [method, params])
            translate(caller, :create, apply(caller, :run, [method, params]))
          _ -> raise "action `:create` not allowed for #{unquote(schema)}"
        end
      end

      def update(params, caller \\ FreshbooksApiClient.Caller.HttpXml) do
        case Enum.member?(unquote(allowed), :update) do
          true ->
            method = resource() <> ".update"
            translate(caller, :update, apply(caller, :run, [method, params]))
          _ -> raise "action `:update` not allowed for #{unquote(schema)}"
        end
      end

      def get(params, caller \\ FreshbooksApiClient.Caller.HttpXml) do
        case Enum.member?(unquote(allowed), :get) do
          true ->
            method = resource() <> ".get"
            translate(caller, :get, apply(caller, :run, [method, params]))
            _ -> raise "action `:get` not allowed for #{unquote(schema)}"
        end
      end

      def delete(params, caller \\ FreshbooksApiClient.Caller.HttpXml) do
        case Enum.member?(unquote(allowed), :delete) do
          true ->
            method = resource() <> ".delete"
            translate(caller, :delete, apply(caller, :run, [method, params]))
          _ -> raise "action `:delete` not allowed for #{unquote(schema)}"
        end
      end

      def list(params \\ [], caller \\ FreshbooksApiClient.Caller.HttpXml) do
        case Enum.member?(unquote(allowed), :list) do
          true ->
            method = resource() <> ".list"
            translate(caller, :list, apply(caller, :run, [method, params]))
          _ -> raise "action `:list` not allowed for #{unquote(schema)}"
        end
      end

      def translate(_, _, {:fail, xml}), do: raise "XML Error: #{xml}"

      def translate(_, _, {:error, :unauthorized}), do: raise "Unauthorized!"

      def translate(_, _, {:error, :conn}), do: raise "HTTP Connection Error!"

      def translate(FreshbooksApiClient.Caller.HttpXml, :get, {:ok, xml}) do
        FreshbooksApiClient.Interface.translate(__MODULE__, unquote(schema), FreshbooksApiClient.Caller.HttpXml, :get, {:ok, xml})
      end

      def translate(FreshbooksApiClient.Caller.HttpXml, :list, {:ok, xml}) do
        FreshbooksApiClient.Interface.translate(__MODULE__, unquote(schema), FreshbooksApiClient.Caller.HttpXml, :list, {:ok, xml})
      end

      def translate(_, _, _) do
        raise "translate/3 not implemented for #{__MODULE__}"
      end

      def to_schema(params) do
        FreshbooksApiClient.Interface.to_schema(unquote(schema), params)
      end

      def parse_date(value) do
        FreshbooksApiClient.Interface.parse_date(value)
      end

      def parse_decimal(value) do
        FreshbooksApiClient.Interface.parse_decimal(value)
      end

      def parse_boolean(value) do
        FreshbooksApiClient.Interface.parse_boolean(value)
      end

      def parse_datetime(value) do
        FreshbooksApiClient.Interface.parse_datetime(value)
      end

      defoverridable [{:resource, 0}, {:resources, 0}, {:translate, 3} | Enum.map(unquote(allowed), &{&1, 2})]
    end
  end

  def translate(interface, schema, FreshbooksApiClient.Caller.HttpXml, :get, {:ok, xml}) do
    {parent, spec} = apply(interface, :xml_parent_spec, [:get])

    params = xml
    |> xpath(parent, spec)

    to_schema(schema, params)
  end

  def translate(interface, schema, FreshbooksApiClient.Caller.HttpXml, :list, {:ok, xml}) do
    resources_key = apply(interface, :resources, [])
    per_page = xml |> xpath(~x"//response/#{resources_key}/@per_page"s) |> String.to_integer()
    page = xml |> xpath(~x"//response/#{resources_key}/@page"s) |> String.to_integer()
    pages = xml |> xpath(~x"//response/#{resources_key}/@pages"s) |> String.to_integer()
    total = xml |> xpath(~x"//response/#{resources_key}/@total"s) |> String.to_integer()

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

  def to_schema(schema, params) do
    struct!(schema, params)
  end

  def call(interface, method, params \\ []) do
    use Retry

    retry with: [5_000, 30_000, 60_000], rescue_only: [FreshbooksApiClient.RateLimitError] do
      call_without_retry(interface, method, params)
    end
  end

  # TODO: I'm not sure what a rate limit error looks like, but when we get one we need to raise this exception
  def call_without_retry(interface, method, params) do
    apply(interface, method, [params])
  end

  def all(interface, params \\ []) do
    use Retry

    retry with: [5_000, 30_000, 60_000], rescue_only: [FreshbooksApiClient.PaginationError] do
      all_without_retry(interface, params)
    end
  end

  # Failure Scenarios (per_page: 3)
  # 1,2,3 + 4,5,6 total == 6

  # delete 3 after page 1
  # 1,2,3, + 5,6 total == 5 (total count changed)

  # add 7 after page 1
  # 1,2,3 + 4,5,6 + 7 total == 7 (total count & total_pages changed - we could just grab another page)

  # delete 3, add 7 after page 1
  # 1,2,3 + 5,6,7 total == 6 (the results are inaccurate - Check that #4 is actually deleted w/ a get call to the API)
  def all_without_retry(interface, params) do
    results = call(interface, :list, [Keyword.merge(params, [per_page: 100])])

    pages = results[:pages]
    total = results[:total]
    resources = results[:resources]

    if pages == 1 do
      resources
    else
      Enum.reduce(Range.new(2, pages), resources, fn(page, acc) ->
        results = call(interface, :list, [Keyword.merge(params, [per_page: 100, page: page])])

        if results[:total] != total, do: raise FreshbooksApiClient.PaginationError

        acc ++ results[:resources]
      end)
    end
  end

  def parse_date(value) do
    case value do
      "" -> nil
      _ ->
        # Some date's also have a time component: 2018-01-01 00:00:00
        String.split(value, " ")
        |> List.first
        |> Date.from_iso8601!
    end
  end

  def parse_decimal(value) do
    case value do
      "" -> nil
      _ -> Decimal.new(value)
    end
  end

  def parse_boolean(value) do
    value == "1"
  end

  def parse_datetime(value) do
    case value do
      "" -> nil
      _ -> NaiveDateTime.from_iso8601!(value)
    end
  end
end
