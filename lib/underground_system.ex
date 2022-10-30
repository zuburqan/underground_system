defmodule UndergroundSystem do
  def process(rows) do
    rows
    |> Enum.reduce({%{}, %{}, []}, fn row, acc ->
      {check_ins, check_outs, result} = acc

      case row do
        {"check_in", id, station, time} ->
          {check_in(check_ins, id, station, time), check_outs, result}

        {"check_out", id, station, time} ->
          {check_ins, check_out(check_outs, id, station, time), result}

        {"get_average", start_station, end_station} ->
          {check_ins, check_outs, get_average_time(acc, start_station, end_station)}
      end
    end)
  end

  def check_in(check_ins, id, station, time) do
    past_check_ins = Map.get(check_ins, station, [])

    check_ins
    |> Map.put(station, past_check_ins ++ [{id, time}])
  end

  def check_out(check_outs, id, station, time) do
    past_check_outs = Map.get(check_outs, station, [])

    check_outs
    |> Map.put(station, past_check_outs ++ [{id, time}])
  end

  def get_average_time(journeys, start_station, end_station) do
    {check_ins, check_outs, result} = journeys

    entries = entry_exit(check_ins, start_station)
    exits = entry_exit(check_outs, end_station)

    timings =
      Map.keys(entries)
      |> Enum.map(&{extract(entries, &1), extract(exits, &1)})

    sum =
      timings
      |> IO.inspect()
      |> Enum.map(fn timing -> 
        {start, ending} = timing
        if ending > start do
          (ending - start)
        else
          start
        end
      end)
      |> IO.inspect(label: AFTER)
      |> Enum.sum()

    average = sum / (length(timings) * 1.0)

    result ++ ["#{start_station},#{end_station},#{average}"]
  end

  defp extract(list, id) do
    time = 
    Map.get(list, id, [])
    |> Enum.map(&elem(&1, 1))
    |> Enum.map(&(Integer.parse(&1) |> elem(0)))
    # check this logic
    |> List.last()

    time || 0
  end

  defp entry_exit(journeys, station) do
    Map.get(journeys, station, [])
    |> Enum.group_by(&elem(&1, 0))
  end
end
