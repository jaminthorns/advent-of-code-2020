defmodule Day10 do
  @behaviour Solution

  @test_input_small """
  16
  10
  15
  5
  1
  11
  7
  19
  6
  12
  4
  """

  @test_input_large """
  28
  33
  18
  42
  31
  14
  46
  20
  48
  47
  24
  23
  49
  45
  19
  38
  39
  11
  1
  32
  25
  35
  8
  17
  7
  9
  4
  2
  34
  10
  3
  """

  @doc """
  iex> solve_part_1(#{inspect(@test_input_small)})
  35

  iex> solve_part_1(#{inspect(@test_input_large)})
  220
  """
  def solve_part_1(input) do
    differences = input |> joltages() |> differences()
    amounts = Enum.frequencies(differences)

    amounts[1] * amounts[3]
  end

  @doc """
  iex> solve_part_2(#{inspect(@test_input_small)})
  8

  iex> solve_part_2(#{inspect(@test_input_large)})
  19208
  """
  def solve_part_2(input) do
    input
    |> joltages()
    |> differences()
    |> arrangements()
  end

  defp joltages(input) do
    input
    |> String.split()
    |> Enum.map(&String.to_integer/1)
    |> Enum.sort()
    |> ends()
  end

  defp ends(joltages) do
    [0] ++ joltages ++ [Enum.max(joltages) + 3]
  end

  defp differences(joltages) do
    joltages
    |> Enum.drop(1)
    |> Enum.zip(joltages)
    |> Enum.map(fn {current, prev} -> current - prev end)
  end

  defp arrangements(differences) do
    differences
    |> Enum.reduce([0], fn
      1, [current | ones] -> [current + 1 | ones]
      3, ones -> [0 | ones]
    end)
    |> Enum.map(&sequence/1)
    |> Enum.reduce(&Kernel.*/2)
  end

  defp sequence(0), do: 1
  defp sequence(1), do: 1
  defp sequence(2), do: 2
  defp sequence(n), do: sequence(n - 1) + sequence(n - 2) + sequence(n - 3)
end
