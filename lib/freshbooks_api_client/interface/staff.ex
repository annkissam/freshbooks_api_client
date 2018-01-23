defmodule FreshbooksApiClient.Interface.Staff do
  @moduledoc """
  This module handles the interface operations to interact with Freshbooks
  staff resource.

  It uses a FreshbooksApiClient.Interface
  """

  import SweetXml

  alias FreshbooksApiClient.Schema.Staff

  use FreshbooksApiClient.Interface, schema: Staff, allow: ~w(get list)a

  def translate(_, _, {:error, :unauthorized}), do: raise "Unauthorized!"
  def translate(_, _, {:error, :conn}), do: raise "HTTP Connection Error!"
  def translate(FreshbooksApiClient.Caller.HttpXml, :get, {:ok, xml}) do
    xml
    |> xpath(
      ~x"//response/#{apply(Staff, :resource, [])}",
      Staff
      |> apply(:__schema__, [:fields])
      |> Enum.map(&{&1, ~x"./#{&1}/text()"s}))
  end
  # This is really weird for Staff Resource.
  # This is super inconsistent and hopefully Freshbooks will change it in
  # future.
  def translate(FreshbooksApiClient.Caller.HttpXml, :list, {:ok, xml}) do
    xml
    |> xpath(
      ~x"//response/staff_members/member"l,
      Staff
      |> apply(:__schema__, [:fields])
      |> Enum.map(&{&1, ~x"./#{&1}/text()"s}))
    |> Enum.map(&to_schema/1)
  end
  defp transform(:staff_id, params) do
    Map.update!(params, :staff_id, &String.to_integer/1)
  end
  defp transform(:number_of_logins, params) do
    Map.update!(params, :number_of_logins, fn curr ->
      case curr do
        "" -> nil
        _ -> String.to_integer(curr)
      end
    end)
  end
  defp transform(:rate, params) do
    Map.update!(params, :rate, fn curr ->
      case curr do
        "" -> nil
        _ -> (curr |> Float.parse() |> elem(0))
      end
    end)
  end
  defp transform(:last_login, params) do
    Map.update!(params, :last_login, fn curr ->
      case curr do
        "" -> nil
        _ -> NaiveDateTime.from_iso8601!(curr)
      end
    end)
  end
  defp transform(:signup_date, params) do
    Map.update!(params, :signup_date, fn curr ->
      case curr do
        "" -> nil
        _ -> NaiveDateTime.from_iso8601!(curr)
      end
    end)
  end
  defp transform(_field, params), do: params
end
