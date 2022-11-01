defmodule OrchestratorTest do
  use ExUnit.Case

  test "reads file 1 and generates answer" do
    file_path = "fixture_1.txt"

    assert Orchestrator.run(file_path) == "Paradise,Cambridge,14.0"
  end

  test "reads file 2 and generates answer" do
    file_path = "fixture_2.txt"

    assert Orchestrator.run(file_path) ==
             "Paradise,Cambridge,14.0\nLeyton,Waterloo,11.0\nLeyton,Waterloo,12.0"
  end
end
