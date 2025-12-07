defmodule Seven do
  def run() do
    [start | tail] =
      Adventofcode.load_text(7)
      |> String.split("\n")
      |> Enum.map(fn line ->
        String.to_charlist(line)
        |> Enum.with_index()
        |> Enum.reject(fn {char, _index} -> char == ?. end)
      end)
      |> Enum.reject(&Enum.empty?/1)
      |> Enum.map(fn line ->
        Enum.map(line, fn {_char, index} -> index end)
      end)

    Enum.reduce(tail, {MapSet.new(start), 0}, fn pos, acc ->
      {pos_list, n} = acc
      pos = pos |> MapSet.new()
      in_list = MapSet.intersection(pos_list, pos)
      number = Enum.count(in_list)
      out_list = MapSet.difference(MapSet.new(pos_list), MapSet.new(pos))

      new_list =
        MapSet.union(in_list |> Enum.flat_map(&split(&1)) |> MapSet.new(), out_list)

      {new_list, n + number}
    end)
  end

  def split(n), do: [n - 1, n + 1]

  def run2() do
    [start | tail] =
      Adventofcode.load_text(7)
      |> String.split("\n")
      |> Enum.map(fn line ->
        String.to_charlist(line)
        |> Enum.with_index()
        |> Enum.reject(fn {char, _index} -> char == ?. end)
      end)
      |> Enum.reject(&Enum.empty?/1)
      |> Enum.map(fn line ->
        Enum.map(line, fn {_char, index} -> index end)
      end)

    map = %{(start |> hd()) => 1}

    Enum.reduce(tail, map, fn splitter, streger ->
      Enum.reduce(streger |> Map.keys(), streger, fn streg, map ->
        if map[streg] >= 1 do
          split(streg, streg in splitter, map)
        else
          map
        end
      end)
    end)
    |> Map.values()
    |> Enum.sum()
  end

  def split(n, true, map) do
    amount = Map.get(map, n, 0)

    Map.update(map, n, 1, fn _ -> 0 end)
    |> Map.update(n - 1, 1, fn x -> x + amount end)
    |> Map.update(n + 1, 1, fn x -> x + amount end)
  end

  def split(_, false, map), do: map
end
