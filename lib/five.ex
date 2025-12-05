defmodule Five do
  def run() do
    [range, ids] =
      Adventofcode.load_text(5)
      |> String.split("\n\n")

    range =
      range
      |> String.split("\n")
      |> Enum.reduce([], fn x, acc ->
        tup =
          String.split(x, "-") |> Enum.map(fn x -> String.to_integer(x) end) |> List.to_tuple()

        [tup | acc]
      end)

    ids
    |> String.split("\n")
    |> Enum.reduce(0, fn x, acc ->
      x = String.to_integer(x)

      count =
        Enum.reduce_while(range, false, fn range, acc ->
          {min, max} = range

          if min <= x and x <= max do
            {:halt, true}
          else
            {:cont, acc}
          end
        end)

      if count do
        acc + 1
      else
        acc
      end
    end)
  end

  def run2() do
    [range, _] =
      Adventofcode.load_text(5)
      |> String.split("\n\n")

    range
    |> String.split("\n")
    |> Enum.map(fn x ->
      String.split(x, "-") |> Enum.map(fn x -> String.to_integer(x) end) |> List.to_tuple()
    end)
    |> Enum.map(fn {min, max} ->
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
    |> Enum.map(fn ran -> Enum.count(ran) end)
    |> Enum.sum()
  end
end
