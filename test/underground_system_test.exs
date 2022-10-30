defmodule UndergroundSystemTest do
  use ExUnit.Case

  test "checks in a customer" do
    result =
      UndergroundSystem.check_in(%{}, 45, "Leyton", 3)
      |> UndergroundSystem.check_in(32, "Paradise", 8)
      |> UndergroundSystem.check_out(45, "Waterloo", 15)
      |> UndergroundSystem.check_out(32, "Cambridge", 22)
      |> UndergroundSystem.get_average_time("Paradise", "Cambridge")

    assert result == 14
  end
end
