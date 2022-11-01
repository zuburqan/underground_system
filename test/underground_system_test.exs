defmodule UndergroundSystemTest do
  use ExUnit.Case

  test "returns processed journey times along with averages in chronology" do
    rows = [
      {"check_in", "45", "Leyton", "3"},
      {"check_out", "45", "Waterloo", "15"},
      {"get_average", "Leyton", "Waterloo"}
    ]

    expected =
      {%{"Leyton" => [{"45", "3"}], "Waterloo" => [{"45", "15"}]}, ["Leyton,Waterloo,12.0"]}

    assert UndergroundSystem.process(rows) == expected
  end

  test "raises when a bad command is found as a row" do
    rows = [
      {"check_inzzzzz", "45", "Leyton", "3"}
    ]

    assert_raise BadRowError,
                 "Bad row {\"check_inzzzzz\", \"45\", \"Leyton\", \"3\"} encountered",
                 fn ->
                   UndergroundSystem.process(rows)
                 end
  end

  test "raises when bad time is passed" do
    rows = [
      {"check_in", "45", "Leyton", "3"},
      {"check_out", "45", "Waterloo", "foo_time"},
      {"get_average", "Leyton", "Waterloo"}
    ]

    assert_raise BadRowError,
                 "Bad row with time foo_time encountered",
                 fn ->
                   UndergroundSystem.process(rows)
                 end
  end
end
