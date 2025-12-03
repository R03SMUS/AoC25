defmodule Days.Day2 do
  def solve() do
    Adventofcode.load_text(2)
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn lines ->
      String.split(lines, " ")
      |> match()
    end)
    |> Enum.sum()
    |> IO.puts()

    Adventofcode.load_text(2)
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn lines ->
      String.split(lines, " ")
      |> match2()
    end)
    |> Enum.sum()
  end

  @map %{"A" => 1, "B" => 2, "C" => 3, "X" => 0, "Y" => 3, "Z" => 6}

  def match2([one, two]) do
    Map.get(@map, one) + Map.get(@map, two)
  end

  def match(["A", "X"]) do
    3 + 1
  end

  def match(["A", "Y"]) do
    6 + 2
  end

  def match(["A", "Z"]) do
    0 + 3
  end

  def match(["B", "X"]) do
    0 + 1
  end

  def match(["B", "Y"]) do
    3 + 2
  end

  def match(["B", "Z"]) do
    6 + 3
  end

  def match(["C", "X"]) do
    6 + 1
  end

  def match(["C", "Y"]) do
    0 + 2
  end

  def match(["C", "Z"]) do
    3 + 3
  end
end
