defmodule Day1 do
  @behaviour Solution

  @test_input """
  1721
  979
  366
  299
  675
  1456
  """

  @doc """
  iex> solve_part_1(#{inspect(@test_input)})
  514579
  """
  def solve_part_1(input) do
    input
    |> numbers()
    |> find_product_by_sum(2020, 2)
  end

  @doc """
  iex> solve_part_2(#{inspect(@test_input)})
  241861950
  """
  def solve_part_2(input) do
    input
    |> numbers()
    |> find_product_by_sum(2020, 3)
  end

  defp numbers(input) do
    input
    |> String.split()
    |> Enum.map(&String.to_integer/1)
  end

  defp find_product_by_sum(numbers, sum, count, locked \\ [])

  defp find_product_by_sum(_, sum, 0, locked) do
    if Enum.sum(locked) == sum do
      Enum.reduce(locked, &Kernel.*/2)
    end
  end

  defp find_product_by_sum(numbers, sum, count, locked) do
    numbers
    |> Enum.reduce({[], numbers}, fn _, {seqs, seq} -> {[seq | seqs], tl(seq)} end)
    |> elem(0)
    |> Enum.find_value(fn [number | rest] ->
      find_product_by_sum(rest, sum, count - 1, [number | locked])
    end)
  end
end
