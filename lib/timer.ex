defmodule Timer do
  def time(days) when is_list(days) do
    start = Time.utc_now()

    days
    |> Enum.map(fn module ->
      IO.puts("Timing day #{module}:")
      time(module)
    end)

    IO.puts("Total time: #{Time.diff(Time.utc_now(), start)} seconds\n")
  end

  def time(day) do
    start = Time.utc_now()

    day.run()

    slut = Time.utc_now()

    IO.puts("Part 1: #{Time.diff(slut, start, :millisecond)} milliseconds")

    start = Time.utc_now()

    day.run2()

    slut = Time.utc_now()

    IO.puts("Part 2: #{Time.diff(slut, start, :millisecond)} milliseconds")
  end

  def time_all(skip \\ []) do
    start = Time.utc_now()

    skip = List.wrap(skip)

    modules = [One, Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten, Eleven, Tweleve]

    Enum.reduce(skip, modules, fn skip, acc ->
      List.delete(acc, skip)
    end)
    |> Enum.map(fn module ->
      IO.puts("Timing day #{module}:")
      time(module)
    end)

    IO.puts("Total time: #{Time.diff(Time.utc_now(), start)} seconds\n")
  end
end
