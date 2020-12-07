defmodule Day6 do
  @behaviour Solution

  @test_input """
  abc

  a
  b
  c

  ab
  ac

  a
  a
  a
  a

  b
  """

  @doc """
  iex> solve_part_1(#{inspect(@test_input)})
  11
  """
  def solve_part_1(input) do
    input
    |> groups()
    |> yes_count(&MapSet.union/2)
  end

  @doc """
  iex> solve_part_2(#{inspect(@test_input)})
  6
  """
  def solve_part_2(input) do
    input
    |> groups()
    |> yes_count(&MapSet.intersection/2)
  end

  defp groups(input) do
    input
    |> String.split("\n\n")
    |> Enum.map(fn group ->
      group
      |> String.split()
      |> Enum.map(&String.graphemes/1)
    end)
  end

  defp yes_count(group, operation) do
    group
    |> Enum.map(fn answers ->
      answers
      |> Enum.map(&MapSet.new/1)
      |> Enum.reduce(operation)
      |> MapSet.size()
    end)
    |> Enum.sum()
  end
end
