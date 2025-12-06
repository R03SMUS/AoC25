defmodule Six do
  def run() do
    Adventofcode.load_text(6)
    |> String.split("\n")
    |> Enum.map(fn line ->
      String.split(line)
      |> Enum.with_index()
    end)
    |> List.flatten()
    |> Enum.reduce(Map.new(), fn {n, index}, map ->
      Map.put(map, index, [n | Map.get(map, index, [])])
    end)
    |> Enum.map(fn {_, [op | tl]} ->
      numbers = Enum.map(tl, &String.to_integer(&1))

      case op do
        "+" ->
          numbers |> Enum.sum()

        "*" ->
          numbers |> Enum.product()
      end
    end)
    |> Enum.sum()
  end

  def run2() do
    list =
      Adventofcode.load_text(6)
      |> String.split("\n")
      |> Enum.map(fn line ->
        String.to_charlist(line)
      end)

    op = list |> List.last() |> Enum.reject(fn x -> x == 32 end)

    list
    |> Enum.slice(0..-2//1)
    |> Enum.map(fn numbers -> Enum.with_index(numbers) end)
    |> List.flatten()
    |> Enum.reduce(Map.new(), fn {n, index}, map ->
      Map.put(map, index, [n | Map.get(map, index, [])])
    end)
    |> Enum.to_list()
    |> Enum.sort()
    |> Enum.map(fn {_index, n} -> Enum.reverse(n) |> Enum.reject(all, fn x -> x == 32 end) end)
    |> Enum.chunk_by(&(&1 == []))
    |> Enum.filter(fn x -> Enum.any?(x |> List.flatten()) end)
    |> Enum.zip(op)
    |> Enum.map(fn {list, op} ->
      numbers = Enum.map(list, &List.to_integer(&1))

      case op do
        ?+ -> numbers |> Enum.sum()
        ?* -> numbers |> Enum.product()
      end
    end)
    |> Enum.sum()
  end
end

# Map.put(map, number, [n | Map.get(map, number, [])])
