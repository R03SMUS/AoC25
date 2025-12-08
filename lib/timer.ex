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
end
