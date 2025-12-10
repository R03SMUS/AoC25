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
    if state_presses > presses && presses < 10 do
      set(state, presses)
      do_all(target, state, buttons, presses)
    end
  end

  def do_all(target, state, buttons, presses) do
    case Enum.any?(
           for(
             button <- buttons,
             do: MapSet.equal?(target, MapSet.symmetric_difference(state, button))
           )
         ) do
      true ->
        [presses + 1]

      false ->
        for(
          button <- buttons,
          do: find_min(target, MapSet.symmetric_difference(state, button), buttons, presses + 1)
        )
    end
  end

  def get(state) do
    Map.get(Agent.get(__MODULE__, & &1), state)
  end

  def set(state, presses) do
    Agent.update(
      __MODULE__,
      &Map.update(&1, state, presses, fn current -> min(presses, current) end)
    )
  end

  def run2() do
    Adventofcode.load_text(10)
    |> String.split("\r\n")
    |> Enum.with_index()
    |> Enum.map(fn {lines, index} ->
      [_target | tail] = String.split(lines, " ")

      joltage =
        List.last(tail)
        |> String.trim("{")
        |> String.trim("}")
        |> String.split(",")
        |> Enum.map(&String.to_integer/1)
        |> Enum.with_index()
        |> Map.new(fn {val, index} -> {index, val} end)

      buttons =
        Enum.drop(tail, -1)
        |> Enum.map(fn line ->
          String.trim(line, "(")
          |> String.trim(")")
          |> String.split(",")
          |> Enum.map(&String.to_integer/1)
          |> MapSet.new()
        end)

      state = Map.new(0..(map_size(joltage) - 1), fn key -> {key, 0} end)
      {:ok, pid} = Agent.start_link(fn -> {%{}, nil} end, name: __MODULE__)

      res =
        find_min2(joltage, state, buttons, 0)
        |> List.flatten()
        |> Enum.reject(&Kernel.is_nil/1)
        |> Enum.min()

      IO.puts("#{index}: #{res}")
      Agent.stop(pid)
      res
    end)
    |> Enum.sum()
  end

  def find_min2(target, state, buttons, presses) do
    {state_presses, _min} = get2(state)

    cond do
      state_presses != nil and state_presses <= presses ->
        nil

      Map.equal?(target, state) ->
        presses

      true ->
        set2(state, presses)
        perform2(target, state, buttons, presses)
    end
  end

  def perform2(target, state, buttons, presses) do
    # state -> number of presses
    case get2(state) do
      {nil, _} ->
        set2(state, presses)
        perform2(target, state, buttons, presses)

      {state_presses, current_min} ->
        less2(target, presses, state_presses, state, buttons, current_min)
    end
  end

  def do_all2(target, state, buttons, presses) do
    next_presses = presses + 1

    if Enum.any?(for button <- buttons, do: Map.equal?(target, press_button(state, button))) do
      {_state_presses, current_min} = get2(state)

      if current_min == nil or next_presses < current_min do
        set2_sol(state, next_presses)
      end
    else
      for button <- buttons do
        find_min2(target, press_button(state, button), buttons, next_presses)
      end
    end
  end

  def less2(target, presses, state_presses, state, buttons, current_min) do
    if presses < current_min && state_presses >= presses && is_valid(target, state) do
      set2(state, presses)
      do_all2(target, state, buttons, presses)
    end
  end

  def press_button(state, button) do
    Enum.reduce(button, state, fn button, state_acc ->
      Map.update(state_acc, button, 1, &(&1 + 1))
    end)
  end

  def is_valid(target, state) do
    # dbg(state)
    # dbg(target)

    Enum.zip(
      Map.values(target),
      Map.values(state)
    )
    |> Enum.all?(fn {targetx, statex} -> statex <= targetx end)

    # |> dbg()
  end

  use Agent

  def get2(state) do
    {map, min} = Agent.get(__MODULE__, & &1)
    {Map.get(map, state), min}
  end

  def set2(state, presses) do
    Agent.update(
      __MODULE__,
      fn {map, min} ->
        {Map.update(map, state, presses, fn current -> min(presses, current) end), min}
      end
    )
  end

  def set2_sol(state, presses) do
    Agent.update(
      __MODULE__,
      fn {map, min} ->
        {Map.update(map, state, presses, fn current -> min(presses, current) end),
         min(presses, min)}
      end
    )

    presses
  end
end
