defmodule Orchestrator do
  @moduledoc """
  Kicks off the shaping and average calculation logic. Outputs the final result in desired format.

  Example output:
  station_1,station_2,avg_time_a
  station_3,station_4,avg_time_b
  """

  def print_run(file_path) do
    file_path
    |> run()
    |> IO.inspect()
  end

  def run(file_path) do
    File.read!(file_path)
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.split(&1, ","))
    |> Enum.map(&List.to_tuple/1)
    |> UndergroundSystem.process()
    |> elem(1)
    |> Enum.uniq()
    |> Enum.join("\n")
  rescue
    error -> "There was an issue #{error.message}"
  end
end
