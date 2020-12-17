defmodule Day15 do
  @behaviour Solution

  @test_input """
  0,3,6
  """

  @doc """
  iex> solve_part_1(#{inspect(@test_input)})
  436
  """
  def solve_part_1(input) do
    input
    |> numbers()
    |> spoken(2020)
  end

  def solve_part_2(input) do
    input
    |> numbers()
    |> spoken(30_000_000)
  end

  defp numbers(input) do
    input
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  defp spoken(numbers, turn) do
    {earlier, [prev]} = Enum.split(numbers, -1)
    spoken = earlier |> Stream.with_index(1) |> Map.new()

    turns =
      numbers
      |> length()
      |> Stream.iterate(&(&1 + 1))
      |> Stream.transform({prev, spoken}, &next/2)

    numbers
    |> Stream.concat(turns)
    |> Enum.at(turn - 1)
  end

  defp next(turn, {prev, spoken}) do
    last_spoken = Map.get(spoken, prev, turn)
    current = turn - last_spoken
    spoken = Map.put(spoken, prev, turn)

    {[current], {current, spoken}}
  end
end
