defmodule Ten do
  def run() do
    Adventofcode.load_text(10)
    |> String.split("\r\n")
    |> Enum.with_index()
    |> Enum.map(fn {lines, index} ->
      [target | tail] = String.split(lines, " ")

      target =
        String.trim(target, "[")
        |> String.trim("]")
        |> String.graphemes()
        |> Enum.with_index()
        |> MapSet.new(fn {code, index} ->
          case code do
            "#" -> index
            _ -> -1
          end
        end)
        |> MapSet.delete(-1)

      _joltage = List.last(tail)

      buttons =
        Enum.drop(tail, -1)
        |> Enum.map(fn line ->
          String.trim(line, "(")
          |> String.trim(")")
          |> String.split(",")
          |> Enum.map(&String.to_integer/1)
          |> MapSet.new()
        end)

      state = MapSet.new()
      {:ok, pid} = Agent.start_link(fn -> %{} end, name: __MODULE__)
      res = find_min(target, state, buttons, 0) |> List.flatten() |> Enum.min()
      IO.puts("#{index}: #{res}")
      Agent.stop(pid)
      res
    end)
    |> Enum.sum()
  end

  def find_min(target, state, buttons, presses) do
    case MapSet.equal?(target, state) do
      true ->
        presses

      false ->
        perform(target, state, buttons, presses)
    end
  end

  def perform(target, state, buttons, presses) do
    # state -> number of presses
    case get(state) do
      nil ->
        set(state, presses)
        do_all(target, state, buttons, presses)

      state_presses ->
        less(target, presses, state_presses, state, buttons)
    end
  end

  def less(target, presses, state_presses, state, buttons) do
    if state_presses > presses do
      set(state, presses)
      do_all(target, state, buttons, presses)
    end
  end

  def do_all(target, state, buttons, presses) do
    for(
      button <- buttons,
      do: find_min(target, MapSet.symmetric_difference(state, button), buttons, presses + 1)
    )
  end

  use Agent

  def get(state) do
    Map.get(Agent.get(__MODULE__, & &1), state)
  end

  def set(state, presses) do
    Agent.update(
      __MODULE__,
      &Map.update(&1, state, presses, fn current -> min(presses, current) end)
    )
  end
end
