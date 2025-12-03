defmodule Days.Day1 do
  def run() do
    Adventofcode.load_text(1)
    |> solve_1()
    |> solve_2()
  end

  def solve_1(input) do
    result =
      input
      |> String.trim()
      |> String.split(~r"\n\n")
      |> Enum.map(fn x ->
        String.split(x, ~r"\n")
        |> Enum.map(&String.to_integer(&1))
        |> Enum.sum()
      end)
      |> Enum.max()

    IO.puts(result)
    input
  end

  def solve_2(input) do
    result =
      input
      |> String.trim()
      |> String.split(~r"\n\n")
      |> Enum.map(fn x ->
        String.split(x, ~r"\n")
        |> Enum.map(&String.to_integer(&1))
        |> Enum.sum()
      end)
      |> Enum.sort(:desc)
      |> Enum.take(3)
      |> Enum.sum()

    IO.puts(result)
  end
end
