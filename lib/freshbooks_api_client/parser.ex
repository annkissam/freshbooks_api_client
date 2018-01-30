defmodule FreshbooksApiClient.Parser do
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
