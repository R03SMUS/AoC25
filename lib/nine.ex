defmodule Nine do
  def run() do
    coords =
      Adventofcode.load_text(9)
      |> String.split("\n")
      |> Enum.map(fn line ->
        String.split(line, ",") |> Enum.map(&String.to_integer/1)
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
    [x1, y1] = coord1
    [x2, y2] = coord2

    (abs(x2 - x1) + 1) * (abs(y2 - y1) + 1)
  end

  def is_rectangle?(rect) do
    abs(rect.x2 - rect.x1) != abs(rect.y2 - rect.y1)
  end

  def is_rectangle?(coord1, coord2) do
    [x1, y1] = coord1
    [x2, y2] = coord2
    abs(x2 - x1) != abs(y2 - y1) and coord1 != coord2
  end

  def run2() do
    coords =
      Adventofcode.load_text(9)
      |> String.split("\n")
      |> Enum.map(fn line ->
        String.split(line, ",") |> Enum.map(&String.to_integer/1)
      end)

    Enum.map(coords, fn coord1 ->
      Enum.reduce(coords, 0, fn coord2, acc ->
        intersects(coord1, coord2, coords) |> size(coord1, coord2) |> max(acc)
      end)
    end)
    |> Enum.max()
  end

  def intersects([x1, y1], [x2, y2], coords) do
    Enum.zip(coords, tl(coords) ++ [hd(coords)])
    |> Enum.all?(fn {[x3, y3], [x4, y4]} ->
      away?([x3, y3], [x4, y4], x1, y1, x2, y2)
    end)
  end

  # https://aoc.oppi.li/2.5-day-9.html#day-9
  # Has been a massive help.
  # I kinda cheated here, so i wont submit my answer, so i dont know if it even is correct :3
  # I couldn't figure out how to make the check for if the box was inside, the polygon
  defp away?([x1, y1], [x2, y2], x, y, x_prime, y_prime) do
    max(x1, x2) <= min(x, x_prime) or
      min(x1, x2) >= max(x, x_prime) or
      max(y1, y2) <= min(y, y_prime) or
      min(y1, y2) >= max(y, y_prime)
  end
end
