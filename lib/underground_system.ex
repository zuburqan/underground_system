defmodule UndergroundSystem do
  @moduledoc """
  Processes the rows to shape data for easy computation and returns journey map
  and the averages whenever they are requested in chronological order.

  Example input:
  [
    {"check_in", "45", "Leyton", "3"},
    {"check_out", "45", "Waterloo", "15"},
    {"get_average", "Leyton", "Waterloo"}
  ]

  Example output:
  {
    %{
    "Leyton" => [{"45", "3"}],
    "Waterloo" => [{"45", "15"}]
     }, 
    ["Leyton,Waterloo,12.0"]
  }
  """

  def process(rows) do
    rows
    |> Enum.reduce({%{}, []}, fn row, acc ->
      {journeys, result} = acc

      case row do
        {"check_in", id, station, time} ->
          {travel(journeys, id, station, time), result}

        {"check_out", id, station, time} ->
          {travel(journeys, id, station, time), result}

        {"get_average", start_station, end_station} ->
          {journeys, get_average_time(acc, start_station, end_station)}
      end
    end)
  end

  defp travel(journeys, id, station, time) do
    past_check_ins = Map.get(journeys, station, [])

    journeys
    |> Map.put(station, past_check_ins ++ [{id, time}])
  end

  defp get_average_time(journeys, start_station, end_station) do
    {trips, result} = journeys

    entries = entry_exit(trips, start_station)
    exits = entry_exit(trips, end_station)

    timings =
      Map.keys(entries)
      |> Enum.map(&{extract(entries, &1), extract(exits, &1)})
      |> Enum.reject(&(is_nil(elem(&1, 0)) || is_nil(elem(&1, 1))))

    sum =
      timings
      |> Enum.map(fn timing ->
        {start, ending} = timing

        if ending > start do
          ending - start
        end
      end)
      |> Enum.reject(&is_nil(&1))
      |> Enum.sum()

    average = sum / (length(timings) * 1.0)

    result ++ ["#{start_station},#{end_station},#{average}"]
  end

  defp extract(list, id) do
    Map.get(list, id, [])
    |> Enum.map(&elem(&1, 1))
    |> Enum.map(&(Integer.parse(&1) |> elem(0)))
    |> List.last()
  end

  defp entry_exit(journeys, station) do
    Map.get(journeys, station, [])
    |> Enum.group_by(&elem(&1, 0))
  end
end
