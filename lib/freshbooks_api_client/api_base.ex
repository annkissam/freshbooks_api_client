defmodule FreshbooksApiClient.ApiBase do
  defmacro __using__(opts) do
    otp_app = Keyword.get(opts, :otp_app)

    quote do
      the_otp_app = unquote(otp_app)
      the_opts = unquote(opts)

      @config fn ->
        the_otp_app |> Application.get_env(__MODULE__, []) |> Keyword.merge(the_opts)
      end
      @config_with_key fn key -> @config.() |> Keyword.get(key) end
      @config_with_key_and_default fn key, default ->
        @config.() |> Keyword.get(key, default)
      end

      def config do
        unquote(otp_app)
        |> Application.get_env(__MODULE__, [])
        |> Keyword.merge(unquote(opts))
      end

      def config(key, default \\ nil) do
        config()
        |> Keyword.get(key, default)
      end

      def caller() do
        config(:caller, FreshbooksApiClient.Caller.HttpXml)
      end

      def token() do
        config(:token)
      end

      def subdomain() do
        config(:subdomain)
      end

      def list(interface, params \\ []) do
        FreshbooksApiClient.ApiBase.list(__MODULE__, interface, params)
      end

      def get(interface, params) do
        FreshbooksApiClient.ApiBase.get(__MODULE__, interface, params)
      end

      def get!(interface, params) do
        FreshbooksApiClient.ApiBase.get!(__MODULE__, interface, params)
      end

      def create(interface, params) do
        FreshbooksApiClient.ApiBase.create(__MODULE__, interface, params)
      end

      def update(interface, params) do
        FreshbooksApiClient.ApiBase.update(__MODULE__, interface, params)
      end

      def delete(interface, params) do
        FreshbooksApiClient.ApiBase.delete(__MODULE__, interface, params)
      end
    end
  end

  def list(module, interface, params) do
    all(module, interface, params)
  end

  def get(module, interface, params) do
    call(module, interface, :get, params)
  end

  def get!(module, interface, params) do
    case get(module, interface, params) do
      {:ok, resource} -> resource
      {:error, _errors} -> raise FreshbooksApiClient.NoResultsError
    end
  end

  def create(module, interface, params) do
    call(module, interface, :create, params)
  end

  def update(module, interface, params) do
    call(module, interface, :update, params)
  end

  def delete(module, interface, params) do
    call(module, interface, :delete, params)
  end

  defp call(module, interface, method, params) do
    use Retry

    retry with: [5_000, 30_000, 60_000], rescue_only: [FreshbooksApiClient.RateLimitError] do
      call_without_retry(module, interface, method, params)
    end
  end

  # TODO: I'm not sure what a rate limit error looks like, but when we get one we need to raise this exception
  defp call_without_retry(module, interface, method, params) do
    apply(interface, method, [module, params])
  end

  defp all(module, interface, params) do
    use Retry

    retry with: [5_000, 30_000, 60_000], rescue_only: [FreshbooksApiClient.PaginationError] do
      all_without_retry(module, interface, params)
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
  defp all_without_retry(module, interface, params) do
    results = call(module, interface, :list, [Keyword.merge(params, [per_page: 100])])

    pages = results[:pages]
    total = results[:total]
    resources = results[:resources]

    if pages == 1 do
      resources
    else
      Enum.reduce(Range.new(2, pages), resources, fn(page, acc) ->
        results = call(module, interface, :list, [Keyword.merge(params, [per_page: 100, page: page])])

        if results[:total] != total, do: raise FreshbooksApiClient.PaginationError

        acc ++ results[:resources]
      end)
    end
  end

  # def struct_to_interface(FreshbooksApiClient.Schema.Client), do: FreshbooksApiClient.Interface.Clients
  # def struct_to_interface(FreshbooksApiClient.Schema.Invoice), do: FreshbooksApiClient.Interface.Invoices
  # def struct_to_interface(FreshbooksApiClient.Schema.Project), do: FreshbooksApiClient.Interface.Projects
  # def struct_to_interface(FreshbooksApiClient.Schema.Staff), do: FreshbooksApiClient.Interface.Staff
  # def struct_to_interface(FreshbooksApiClient.Schema.Task), do: FreshbooksApiClient.Interface.Tasks
  # def struct_to_interface(FreshbooksApiClient.Schema.TimeEntry), do: FreshbooksApiClient.Interface.TimeEntries
end
