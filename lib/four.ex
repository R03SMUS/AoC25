defmodule Four do
  def run() do
    Adventofcode.load_text(4)
    |> String.split("\n")
    |> Enum.map(fn line -> String.to_charlist(line) end)
    |> create_map()
    |> checkmap1()
    |> List.flatten()
    |> Enum.count(fn x -> x end)
  end

  def check1(map, x, y) do
    case map[x][y] do
      64 -> fewerthan8?(map, x, y)
      46 -> false
      _ -> map[x][y]
    end
  end

  def fewerthan8?(map, x, y) do
    [
      map[x - 1][y - 1],
      map[x - 1][y],
      map[x - 1][y + 1],
      map[x][y - 1],
      map[x][y + 1],
      map[x + 1][y - 1],
      map[x + 1][y],
      map[x + 1][y + 1]
    ]
    |> Enum.count(fn x -> x == 64 end) < 4
  end

  def run2() do
    Adventofcode.load_text(4)
    |> String.split("\n")
    |> Enum.map(fn line -> String.to_charlist(line) end)
    |> create_map()
    |> checkmap(0)
  end

  def create_map(list) do
    Enum.map(list, fn line ->
      line
      |> Enum.zip(0..1000)
      |> Map.new(fn {val, key} -> {key, val} end)
    end)
    |> Enum.zip(0..1000)
    |> Map.new(fn {val, key} -> {key, val} end)
  end

  def checkmap1(map) do
    Enum.map(0..((map |> Map.keys() |> length()) - 1), fn x ->
      Enum.map(0..((map[x] |> Map.keys() |> length()) - 1), fn y -> check1(map, x, y) end)
    end)
  end

  def checkmap(map, n) do
    list =
      Enum.map(0..((map |> Map.keys() |> length()) - 1), fn x ->
        Enum.map(0..((map[x] |> Map.keys() |> length()) - 1), fn y -> check2(map, x, y) end)
      end)

    changed = list |> List.flatten() |> Enum.count(fn x -> x == 0 end)

    if changed == n do
      n
    else
      checkmap(create_map(list), changed)
    end
  end

  def check2(map, x, y) do
    case map[x][y] do
      64 ->
        if fewerthan8?(map, x, y) do
          0
        else
          64
        end

      46 ->
        46

      _ ->
        map[x][y]
    end
  end
end
