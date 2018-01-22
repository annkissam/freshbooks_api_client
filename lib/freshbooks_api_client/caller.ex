defmodule FreshbooksApiClient.Caller do
  @moduledoc """
  This module defines the behavior a `caller` must implement.

  ## Callbacks:

  * run(opts) -> Makes a request with the given options.

  """

  @callback run(keyword) :: String.t()

  @doc ~S(A Simple way of accessing all Caller's features)
  defmacro __using__(_opts) do
    quote do
      import unquote(__MODULE__)

      @behaviour unquote(__MODULE__)

      def run(_) do
        raise "run/1 not implement for #{__MODULE__}"
      end

      defoverridable [run: 1]
    end
  end
end

