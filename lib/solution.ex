defmodule Solution do
  @callback solve_part_1(binary) :: any
  @callback solve_part_2(binary) :: any

  @doc """
  Solve a puzzle for a given `day` and `part`.
  """
  def solve(day, part) do
    input = File.read!("input/day_#{day}.txt")
    module = String.to_atom("Elixir.Day#{day}")

    case part do
      1 -> module.solve_part_1(input)
      2 -> module.solve_part_2(input)
    end
  end
end
