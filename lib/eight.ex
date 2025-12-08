defmodule Eight do
  def run() do
    coords =
      Adventofcode.load_text(8)
      # done on windows pc :puke:
      |> String.split("\r\n")
      |> Enum.map(fn line ->
        [x, y, z] = String.split(line, ",")
        %{x: String.to_integer(x), y: String.to_integer(y), z: String.to_integer(z)}
      end)

    Enum.flat_map(coords, fn coord ->
      Enum.map(coords, fn coord2 ->
        cond do
          coord == coord2 -> nil
          true -> {coord, coord2, distance(coord, coord2)}
        end
      end)
      |> Enum.reject(fn x -> x == nil end)
    end)
    |> Enum.sort_by(&elem(&1, 2))
    |> Enum.take_every(2)
    |> Enum.take(1000)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {{coord1, coord2, _distance}, index}, acc ->
      combine(acc, coord1, coord2, index)
    end)
    |> Map.values()
    |> Enum.frequencies()
    |> Map.values()
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.product()
  end

  def combine(map, coord1, coord2, index) do
    g1 = Map.get(map, coord1)
    g2 = Map.get(map, coord2)

    cond do
      g1 == nil and g2 == nil ->
        map
        |> Map.put(coord1, index)
        |> Map.put(coord2, index)

      g1 != nil and g2 == nil ->
        Map.put(map, coord2, g1)

      g1 == nil and g2 != nil ->
        Map.put(map, coord1, g2)

      g1 == g2 ->
        map

      true ->
        Enum.reduce(map, map, fn
          {coord, ^g2}, acc -> Map.put(acc, coord, g1)
          _, acc -> acc
        end)
    end
  end

  def distance(map1, map2) do
    (:math.pow(map1[:x] - map2[:x], 2) +
       :math.pow(map1[:z] - map2[:z], 2) +
       :math.pow(map1[:y] - map2[:y], 2))
    |> abs()
    |> :math.sqrt()
  end

  def run2() do
    coords =
      Adventofcode.load_text(8)
      # done on windows pc :puke:
      |> String.split("\r\n")
      |> Enum.map(fn line ->
        [x, y, z] = String.split(line, ",")
        %{x: String.to_integer(x), y: String.to_integer(y), z: String.to_integer(z)}
      end)

    Enum.flat_map(coords, fn coord ->
      Enum.map(coords, fn coord2 ->
        cond do
          coord == coord2 -> nil
          true -> {coord, coord2, distance(coord, coord2)}
        end
      end)
      |> Enum.reject(fn x -> x == nil end)
    end)
    |> Enum.sort_by(&elem(&1, 2))
    |> Enum.take_every(2)
    |> Enum.with_index()
    |> Enum.reduce_while(%{}, fn {{coord1, coord2, _distance}, index}, acc ->
      new_map = combine(acc, coord1, coord2, index)

      new_map
      |> Map.values()
      |> Enum.frequencies()
      |> Map.values()
      |> Enum.sort(:desc)
      |> hd()
      |> then(fn n ->
        if n == 1000 do
          IO.puts(coord1.x * coord2.x)
          {:halt, new_map}
        else
          {:cont, new_map}
        end
      end)
    end)
  end
end
