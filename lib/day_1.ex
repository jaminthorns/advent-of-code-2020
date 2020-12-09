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

  defp find_product_by_sum(numbers, sum, choose) do
    numbers
    |> Util.combinations(choose)
    |> Enum.find(&(Enum.sum(&1) == sum))
    |> Enum.reduce(&Kernel.*/2)
  end
end
