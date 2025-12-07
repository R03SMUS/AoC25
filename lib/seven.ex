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

  def run3() do
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
        # dbg("--------------")
        # dbg(streg)
        # dbg(map)
        # dbg(splitter)

        # dbg(map[streg])
        # dbg(map[streg] >= 1)

        if map[streg] >= 1 do
          split(streg, streg in splitter, map)
        else
          map
        end

        # |> dbg()
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

  def split(n, false, map), do: map

  def run2() do
    [start | tail] =
      Adventofcode.test(7)
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

    now = Time.utc_now()
    result = rec(hd(start), tail)
    Time.diff(Time.utc_now(), now) |> dbg()
    result
  end

  def rec(_, []), do: 1

  def rec(start_pos, splitters) do
    dbg(start_pos)
    head_splitters = hd(splitters)
    tail_splitters = tl(splitters)

    if Enum.member?(head_splitters, start_pos) do
      rec(start_pos - 1, tail_splitters) + rec(start_pos + 1, tail_splitters)
    else
      rec(start_pos, tail_splitters)
    end
  end
end
