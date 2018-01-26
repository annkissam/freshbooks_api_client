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
  * transform(field, params) -> Transforms a field in params from string to
            another type.
  * to_schema(params) -> Converts the params to the specified schema struct.
  """

  alias FreshbooksApiClient.Caller.{HttpXml, InMemory}

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
  @callback tranform(atom(), map()) :: map()
  @callback to_schema(map()) :: Ecto.Schema.t()

  @doc ~S(A Simple way of accessing all of Interace's features)
  defmacro __using__(opts) do
    schema = Keyword.get(opts, :schema)
    allowed = Keyword.get(opts, :allow, @actions)
    interface = __MODULE__

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

      def list(params \\ [], caller \\ FreshbooksApiClient.Caller.HttpXml) do
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
        {parent, spec} = apply(__MODULE__, :xml_parent_spec, [:get])

        xml
        |> xpath(parent, spec)
        |> to_schema()

        # xml
        # |> xpath(
        #   ~x"//response/#{apply(unquote(schema), :resource, [])}",
        #   unquote(schema)
        #   |> apply(:__schema__, [:fields])
        #   |> Enum.map(&{&1, ~x"./#{&1}/text()"s}))
        # |> to_schema()
      end

      def translate(FreshbooksApiClient.Caller.HttpXml, :list, {:ok, xml}) do
        FreshbooksApiClient.Interface.translate(__MODULE__, unquote(schema), FreshbooksApiClient.Caller.HttpXml, :list, {:ok, xml})
      end

      def translate(_, _, _) do
        raise "translate/3 not implemented for #{__MODULE__}"
      end

      defp to_schema(params) do
        FreshbooksApiClient.Interface.to_schema(__MODULE__, unquote(schema), params)
      end

      def transform(_field, params), do: params

      defoverridable [{:translate, 3}, {:transform, 2}
                      | Enum.map(unquote(allowed), &{&1, 2})]
    end
  end

  def translate(interface, schema, FreshbooksApiClient.Caller.HttpXml, :list, {:ok, xml}) do
    resources_key = apply(schema, :resources, [])

    per_page = xml |> xpath(~x"//response/#{resources_key}/@per_page"s) |> String.to_integer()
    page = xml |> xpath(~x"//response/#{resources_key}/@page"s) |> String.to_integer()
    pages = xml |> xpath(~x"//response/#{resources_key}/@pages"s) |> String.to_integer()
    total = xml |> xpath(~x"//response/#{resources_key}/@total"s) |> String.to_integer()

    {parent, spec} = apply(interface, :xml_parent_spec, [:list])

    resources = xml
      |> xpath(parent, spec)
      |> Enum.map(&(to_schema(interface, schema, &1)))

    # schema.__schema__(:embeds)
    # [:lines]

    # schema.__schema__(:embed, :lines)
    # %Ecto.Embedded{cardinality: :many, field: :lines, on_cast: nil,
    #  on_replace: :raise, owner: FreshbooksApiClient.Schema.Invoice,
    #  related: FreshbooksApiClient.Schema.InvoiceLine, unique: true}

    %{
      per_page: per_page,
      page: page,
      pages: pages,
      total: total,
      resources: resources,
    }
  end

  def to_schema(interface, schema, params) do
    castable_params = schema
      |> apply(:__schema__, [:fields])
      |> Enum.reduce(params, &(apply(interface, :transform, [&1, &2])))

    struct!(schema, castable_params)
  end

  def call(interface, method, params \\ []) do
    use Retry

    result = retry with: [5_000, 30_000, 60_000], rescue_only: [FreshbooksApiClient.RateLimitError] do
      call_without_retry(interface, method, params)
    end
  end

  # TODO: I'm not sure what a rate limit error looks like, but when we get one we need to raise this exception
  def call_without_retry(interface, method, params) do
    apply(interface, method, [params])
  end

  def all(interface, params \\ []) do
    use Retry

    result = retry with: [5_000, 30_000, 60_000], rescue_only: [FreshbooksApiClient.PaginationError] do
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
end
