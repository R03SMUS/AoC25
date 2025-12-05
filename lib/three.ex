defmodule Three do
  def run() do
    Adventofcode.load_text(3)
    |> String.split("\n")
    |> Enum.map(fn list ->
      list
      |> String.to_integer()
      |> Integer.digits()
      |> find_max(2)
      |> Integer.undigits()
    end)
    |> Enum.sum()
  end

  def run2() do
    Adventofcode.load_text(3)
    |> String.split("\n")
    |> Enum.map(fn list ->
      list
      |> String.to_integer()
      |> Integer.digits()
      |> find_max(12)
      |> Integer.undigits()
    end)
    |> Enum.sum()
  end

  def find_max(_, 0), do: []

  def find_max(list, number) do
    new_list = list |> Enum.slice(0..-number//1)
    max = new_list |> Enum.max()

    [max | find_max(Enum.drop_while(list, fn x -> x != max end) |> tl(), number - 1)]
  end
end
