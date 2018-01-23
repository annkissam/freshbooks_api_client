defmodule FreshbooksApiClient.Caller do
  @moduledoc """
  This module defines the behavior a `caller` must implement.

  ## Callbacks:

  * run(keys, opts) -> Makes a request with the given keys and options.

  """

  @callback run(keyword, keyword) :: String.t()

  @doc ~S(A Simple way of accessing all Caller's features)
  defmacro __using__(_opts) do
    quote do
      import unquote(__MODULE__)

      @behaviour unquote(__MODULE__)

      def run(_, _) do
        raise "run/2 not implement for #{__MODULE__}"
      end

      defoverridable [run: 2]
    end
  end
end

