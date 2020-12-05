defmodule Day5 do
  @behaviour Solution

  @test_input """
  FBFBBFFRLR
  BFFFBBFRRR
  FFFBBBFRRR
  BBFFBBFRLL
  """

  @doc """
  iex> solve_part_1(#{inspect(@test_input)})
  820
  """
  def solve_part_1(input) do
    input |> seat_ids() |> Enum.max()
  end

  def solve_part_2(input) do
    ids = input |> seat_ids() |> MapSet.new()

    0
    |> Stream.iterate(&(&1 + 1))
    |> Enum.find(fn id -> id not in ids and (id - 1) in ids and (id + 1) in ids end)
  end

  defp seat_ids(input) do
    input
    |> String.split()
    |> Enum.map(fn pass ->
      {row_letters, column_letters} = pass |> String.graphemes() |> Enum.split(7)

      row = seat_index(row_letters, "F", "B")
      column = seat_index(column_letters, "L", "R")

      row * 8 + column
    end)
  end

  defp seat_index(letters, lower, upper) do
    letters
    |> Enum.map(fn
      ^lower -> 0
      ^upper -> 1
    end)
    |> Integer.undigits(2)
  end
end
