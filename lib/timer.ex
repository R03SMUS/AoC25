defmodule Timer do
  def time(day) do
    IO.puts("Part 1: ")

    start = Time.utc_now()

    day.run()

    slut = Time.utc_now()

    IO.puts("#{Time.diff(slut, start, :millisecond)} milliseconds")

    IO.puts("Part 2: ")

    start = Time.utc_now()

    day.run2()

    slut = Time.utc_now()

    IO.puts("#{Time.diff(slut, start, :millisecond)} milliseconds")
  end

  def time_all() do
    start = Time.utc_now()

    [One, Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten, Eleven, Tweleve]
    |> Enum.map(fn module ->
      IO.puts("Timing day #{module}:")
      time(module)
    end)

    IO.puts("Total time: #{Time.diff(Time.utc_now(), start)}")
  end
end
