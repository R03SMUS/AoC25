defmodule Two do
  def run() do
    Adventofcode.load_text(2)
    |> String.split(",")
    |> Enum.map(fn x ->
      [first, second] = String.split(x, "-") |> Enum.map(fn x -> String.to_integer(x) end)
      first..second
    end)
    |> Enum.flat_map(fn x -> x end)
    |> Enum.reject(fn x ->
      list = Integer.to_charlist(x)
      {first, second} = Enum.split(list, div(length(list), 2))
      first != second
    end)
    |> Enum.sum()
  end

  def run2() do
    Adventofcode.load_text(2)
    |> String.split(",")
    |> Enum.map(fn x ->
      [first, second] = String.split(x, "-") |> Enum.map(fn x -> String.to_integer(x) end)
      first..second
    end)
    |> Enum.flat_map(fn x -> x end)
    |> Enum.reject(fn x ->
      list = Integer.to_charlist(x)

      Enum.map(1..max(1, div(list |> length(), 2)), fn n ->
        list |> Enum.chunk_every(n) |> Enum.dedup()
      end)
      |> Enum.reject(fn x -> length(x) > 1 end)
      |> then(fn x -> length(x) < 1 end)
    end)
    |> Enum.reject(fn x -> x < 10 end)
    |> Enum.sum()
  end
end
