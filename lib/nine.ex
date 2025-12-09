defmodule Nine do
  def run() do
    coords =
      Adventofcode.load_text(9)
      |> String.split("\n")
      |> Enum.map(fn line ->
        [x, y] = String.split(line, ",") |> Enum.map(&String.to_integer/1)
        {x, y}
      end)

    Enum.map(coords, fn coord1 ->
      Enum.reduce(coords, 0, fn coord2, acc ->
        is_rectangle?(coord1, coord2) |> size(coord1, coord2) |> max(acc)
      end)
    end)
    |> Enum.max()
  end

  def size(false, _, _), do: 0

  def size(true, coord1, coord2) do
    {x1, y1} = coord1
    {x2, y2} = coord2

    (abs(x2 - x1) + 1) * (abs(y2 - y1) + 1)
  end

  def is_rectangle?(coord1, coord2) do
    {x1, y1} = coord1
    {x2, y2} = coord2
    abs(x2 - x1) != abs(y2 - y1) and coord1 != coord2
  end

  def run2() do
    coords =
      Adventofcode.test(9)
      |> String.split("\n")
      |> Enum.map(fn line ->
        [x, y] = String.split(line, ",") |> Enum.map(&String.to_integer/1)
        {x, y}
      end)

    outside_polygon = coords

    Enum.map(coords, fn coord1 ->
      Enum.reduce(coords, 0, fn coord2, acc ->
        inside_polygon = {coord1, coord2}
        is_rectangle_inside?(inside_polygon, outside_polygon) |> size(coord1, coord2) |> max(acc)
      end)
    end)
    |> Enum.max()
  end

  def is_rectangle_inside?(inside, outside) do
    false
  end
end
