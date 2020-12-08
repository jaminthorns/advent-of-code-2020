defmodule Day8 do
  @behaviour Solution

  @test_input """
  nop +0
  acc +1
  jmp +4
  acc +3
  jmp -3
  acc -99
  acc +1
  jmp -4
  acc +6
  """

  @doc """
  iex> solve_part_1(#{inspect(@test_input)})
  5
  """
  def solve_part_1(input) do
    with {:infinite_loop, acc} <- input |> instructions() |> evaluate() do
      acc
    end
  end

  @doc """
  iex> solve_part_2(#{inspect(@test_input)})
  8
  """
  def solve_part_2(input) do
    instructions = instructions(input)

    instructions
    |> possible_corrupted()
    |> Enum.find_value(fn address ->
      instructions
      |> update_in([address, Access.elem(0)], &change_instruction/1)
      |> evaluate()
      |> case do
        {:terminate, acc} -> acc
        {:infinite_loop, _acc} -> nil
      end
    end)
  end

  defp instructions(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split/1)
    |> Enum.with_index()
    |> Map.new(fn {[op, arg], address} -> {address, {op, String.to_integer(arg)}} end)
  end

  defp evaluate(instructions, current \\ 0, acc \\ 0, run \\ MapSet.new()) do
    next =
      cond do
        current == map_size(instructions) -> :terminate
        current in run -> :infinite_loop
        true -> :continue
      end

    if next == :continue do
      run = MapSet.put(run, current)

      case Map.get(instructions, current) do
        {"acc", amount} -> evaluate(instructions, current + 1, acc + amount, run)
        {"jmp", offset} -> evaluate(instructions, current + offset, acc, run)
        {"nop", _} -> evaluate(instructions, current + 1, acc, run)
      end
    else
      {next, acc}
    end
  end

  defp possible_corrupted(instructions) do
    instructions
    |> Enum.filter(fn {_address, {op, _arg}} -> op in ["jmp", "nop"] end)
    |> Enum.map(&elem(&1, 0))
  end

  defp change_instruction("jmp"), do: "nop"
  defp change_instruction("nop"), do: "jmp"
end
