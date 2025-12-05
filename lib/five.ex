defmodule Five do
  def run() do
    [range, ids] =
      Adventofcode.load_text(5)
      |> String.split("\n\n")

    range =
      range
      |> String.split("\n")
      |> Enum.map(fn x ->
        [min, max] =
          String.split(x, "-") |> Enum.map(fn x -> String.to_integer(x) end)

        min..max
      end)

    ids
    |> String.split("\n")
    |> Enum.reduce(0, fn x, acc ->
      x = String.to_integer(x)

      case inrange?(range, x) do
        true -> acc + 1
        false -> acc
      end
    end)
  end

  def inrange?(range, x) do
    Enum.reduce(range, false, fn y, acc ->
      x in y || acc
    end)
  end

  def run2() do
    [range, _] =
      Adventofcode.load_text(5)
      |> String.split("\n\n")

    range
    |> String.split("\n")
    |> Enum.map(fn x ->
      [min, max] =
        String.split(x, "-") |> Enum.map(fn x -> String.to_integer(x) end)

      min..max
    end)
    |> Enum.sort()
    |> Enum.reduce([..], fn x, acc ->
      head = hd(acc)

      if Range.disjoint?(x, head) do
        [x | acc]
      else
        min..max//_ = head
        min2..max2//_ = x

        [min(min, min2)..max(max, max2)//1 | acc |> tl()]
      end
    end)
    |> Enum.reverse()
    |> tl()
    |> Enum.map(fn ran -> Range.size(ran) end)
    |> Enum.sum()
  end
end
