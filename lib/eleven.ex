defmodule Eleven do
  def run() do
    Adventofcode.load_text(11)
    |> String.split("\r\n")
    |> Enum.reduce(%{}, fn list, map ->
      [key, tail] = String.split(list, ": ")
      dest_list = String.split(tail, " ")
      Map.put(map, key, dest_list)
    end)
    |> rec("you")
    |> List.flatten()
    |> Enum.sum()
  end

  def rec(_map, "out"), do: 1

  def rec(map, start) do
    map[start] |> Enum.map(fn place -> rec(map, place) end)
  end
end
