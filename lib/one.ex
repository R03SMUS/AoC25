defmodule One do
  def run() do
    Adventofcode.load_text(1)
    |> String.split("\n")
    |> Enum.map_reduce(50, fn x, acc ->
      {dir, amount} = String.split_at(x, 1)
      amount = amount |> String.to_integer()

      new_val =
        case dir do
          "R" -> acc + amount
          "L" -> acc - amount
        end

      {new_val, new_val}
    end)
    |> then(fn x ->
      {l, _} = x
      l
    end)
    |> Enum.reject(fn x -> rem(x, 100) != 0 end)
    |> Enum.count()
    |> dbg()
  end

  def run2() do
    Adventofcode.load_text(1)
    |> String.split("\n")
    |> Enum.map_reduce(50, fn x, acc ->
      {dir, amount} = String.split_at(x, 1)
      amount = amount |> String.to_integer()
      min = div(amount, 100)
      amount = amount - min * 100

      case dir do
        "R" ->
          new = Integer.mod(acc + amount, 100)

          add =
            if acc + amount >= 100 && acc != 0 do
              1
            else
              0
            end

          {min + add, new}

        "L" ->
          new = Integer.mod(acc - amount, 100)

          add =
            if acc - amount <= 0 && acc != 0 do
              1
            else
              0
            end

          {min + add, new}
      end
    end)
    |> then(fn x ->
      {l, _} = x
      l
    end)
    |> Enum.sum()
  end
end
