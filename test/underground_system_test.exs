defmodule UndergroundSystemTest do
  use ExUnit.Case
  doctest UndergroundSystem

  test "greets the world" do
    assert UndergroundSystem.hello() == :world
  end
end
