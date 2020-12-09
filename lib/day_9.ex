defmodule Day9 do
  @behaviour Solution

  @test_input """
  35
  20
  15
  25
  47
  40
  62
  55
  65
  95
  102
  117
  150
  182
  127
  219
  299
  277
  309
  576
  """

  @doc """
  iex> solve_part_1(#{inspect(@test_input)}, 5)
  127
  """
  def solve_part_1(input, preamble_length \\ 25) do
    input
    |> numbers()
    |> find_non_sum_number(preamble_length)
  end

  @doc """
  iex> solve_part_2(#{inspect(@test_input)}, 5)
  62
  """
  def solve_part_2(input, preamble_length \\ 25) do
    numbers = numbers(input)
    non_sum_number = find_non_sum_number(numbers, preamble_length)
    sequence = find_sequence_by_sum(numbers, non_sum_number)

    Enum.min(sequence) + Enum.max(sequence)
  end

  defp numbers(input) do
    input
    |> String.split()
    |> Enum.map(&String.to_integer/1)
  end

  defp find_non_sum_number(numbers, preamble_length) do
    Enum.find_value(preamble_length..(length(numbers) - 1), fn index ->
      previous = Enum.slice(numbers, (index - preamble_length)..(index - 1))
      current = Enum.at(numbers, index)

      previous
      |> Util.combinations(2)
      |> Enum.any?(&(Enum.sum(&1) == current))
      |> unless(do: current)
    end)
  end

  defp find_sequence_by_sum(numbers, sum) do
    numbers
    |> Util.subsequences()
    |> Enum.find(&(Enum.sum(&1) == sum))
  end
end
