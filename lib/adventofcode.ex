defmodule Adventofcode do
  def load_text(day) do
    File.read!("input/day#{day}.txt") |> String.trim()
  end

  def test(day) do
    File.read!("input/test#{day}.txt") |> String.trim()
  end
end
