defmodule Orchestrator do
  def run(file_path) do
    File.read!(file_path)
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.split(&1, ","))
    |> Enum.map(&List.to_tuple/1)
    |> UndergroundSystem.process()
    |> elem(2)
    |> Enum.join("\n")
  end
end
