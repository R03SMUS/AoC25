defmodule Three do
  def run() do
    Adventofcode.load_text(3)
    |> String.split("\n")
    |> Enum.map(fn list ->
      list =
        list
        |> String.to_integer()
        |> Integer.digits()

      tl = list |> Enum.reverse() |> hd()

      list
      |> Enum.slice(0, length(list) - 1)
      |> Enum.reduce({0, 0}, fn x, acc ->
        {first, second} = acc

        cond do
          x > first -> {x, 0}
          x > second -> {first, x}
          true -> {first, second}
        end
      end)
      |> then(fn {first, second} ->
        if tl > second do
          {first, tl}
        else
          {first, second}
        end
      end)
      |> Tuple.to_list()
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
