defmodule Day14 do
  @behaviour Solution

  @test_input_mask_values """
  mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
  mem[8] = 11
  mem[7] = 101
  mem[8] = 0
  """

  @test_input_mask_addresses """
  mask = 000000000000000000000000000000X1001X
  mem[42] = 100
  mask = 00000000000000000000000000000000X0XX
  mem[26] = 1
  """

  @doc """
  iex> solve_part_1(#{inspect(@test_input_mask_values)})
  165
  """
  def solve_part_1(input) do
    input
    |> program()
    |> memory_sum(&mask_value/4)
  end

  @doc """
  iex> solve_part_2(#{inspect(@test_input_mask_addresses)})
  208
  """
  def solve_part_2(input) do
    input
    |> program()
    |> memory_sum(&mask_address/4)
  end

  defp program(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&instruction/1)
  end

  defp instruction(instruction) do
    pattern = ~r/mask = (?<mask>.+)|mem\[(?<addr>\d+)\] = (?<val>.+)/

    case Regex.named_captures(pattern, instruction) do
      %{"mask" => mask, "addr" => "", "val" => ""} ->
        {:mask, mask |> String.graphemes() |> Enum.map(&mask_digit/1)}

      %{"mask" => "", "addr" => addr, "val" => val} ->
        {:write, String.to_integer(addr), String.to_integer(val)}
    end
  end

  defp mask_digit("X"), do: nil
  defp mask_digit("0"), do: 0
  defp mask_digit("1"), do: 1

  defp memory_sum(program, apply_mask) do
    program
    |> Enum.reduce({%{}, nil}, &run(&1, &2, apply_mask))
    |> elem(0)
    |> Map.values()
    |> Enum.sum()
  end

  defp run(instruction, {memory, mask}, apply_mask) do
    case instruction do
      {:mask, mask} -> {memory, mask}
      {:write, address, value} -> {apply_mask.(memory, address, value, mask), mask}
    end
  end

  defp mask_value(memory, address, value, mask) do
    value =
      value
      |> zip_mask(mask)
      |> Enum.map(fn
        {digit, nil} -> digit
        {_, 0} -> 0
        {_, 1} -> 1
      end)
      |> Integer.undigits(2)

    Map.put(memory, address, value)
  end

  defp mask_address(memory, address, value, mask) do
    address
    |> zip_mask(mask)
    |> Enum.map(fn
      {_, nil} -> :floating
      {digit, 0} -> digit
      {_, 1} -> 1
    end)
    |> addresses()
    |> Enum.map(&Integer.undigits(&1, 2))
    |> Enum.reduce(memory, &Map.put(&2, &1, value))
  end

  defp zip_mask(number, mask) do
    number
    |> Integer.digits(2)
    |> pad_digits(36)
    |> Enum.zip(mask)
  end

  defp pad_digits(digits, length), do: List.duplicate(0, length - length(digits)) ++ digits

  defp addresses(digits, address \\ []) do
    case digits do
      [] -> [Enum.reverse(address)]
      [:floating | rest] -> Enum.flat_map([0, 1], &addresses(rest, [&1 | address]))
      [digit | rest] -> addresses(rest, [digit | address])
    end
  end
end
