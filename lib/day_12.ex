defmodule Day12 do
  @behaviour Solution

  @test_input """
  F10
  N3
  F7
  R90
  F11
  """

  @doc """
  iex> solve_part_1(#{inspect(@test_input)})
  25
  """
  def solve_part_1(input) do
    input
    |> instructions()
    |> Enum.reduce({{0, 0}, 0}, &move_ship_with_facing/2)
    |> elem(0)
    |> manhattan_distance()
  end

  @doc """
  iex> solve_part_2(#{inspect(@test_input)})
  286
  """
  def solve_part_2(input) do
    input
    |> instructions()
    |> Enum.reduce({{0, 0}, {10, 1}}, &move_ship_with_waypoint/2)
    |> elem(0)
    |> manhattan_distance()
  end

  defp instructions(input) do
    input
    |> String.split()
    |> Enum.map(&String.split_at(&1, 1))
    |> Enum.map(fn {action, value} -> {action(action), String.to_integer(value)} end)
  end

  defp action("N"), do: :north
  defp action("S"), do: :south
  defp action("E"), do: :east
  defp action("W"), do: :west
  defp action("L"), do: :left
  defp action("R"), do: :right
  defp action("F"), do: :forward

  defp move_ship_with_facing(instruction, {ship, facing}) do
    case instruction do
      {:left, degrees} -> {ship, Integer.mod(facing + degrees, 360)}
      {:right, degrees} -> {ship, Integer.mod(facing - degrees, 360)}
      {:forward, value} -> {move_cardinal({direction(facing), value}, ship), facing}
      _ -> {move_cardinal(instruction, ship), facing}
    end
  end

  defp move_ship_with_waypoint(instruction, {ship, waypoint}) do
    case instruction do
      {:left, degrees} -> {ship, rotate(:left, waypoint, degrees)}
      {:right, degrees} -> {ship, rotate(:right, waypoint, degrees)}
      {:forward, value} -> {move_to_waypoint(ship, waypoint, value), waypoint}
      _ -> {ship, move_cardinal(instruction, waypoint)}
    end
  end

  defp move_cardinal(instruction, {x, y}) do
    case instruction do
      {:north, value} -> {x, y + value}
      {:south, value} -> {x, y - value}
      {:east, value} -> {x + value, y}
      {:west, value} -> {x - value, y}
    end
  end

  defp direction(0), do: :east
  defp direction(90), do: :north
  defp direction(180), do: :west
  defp direction(270), do: :south

  defp rotate(_, position, 0), do: position
  defp rotate(:left, {x, y}, degrees), do: rotate(:left, {-y, x}, degrees - 90)
  defp rotate(:right, {x, y}, degrees), do: rotate(:right, {y, -x}, degrees - 90)

  defp move_to_waypoint({x, y}, {dx, dy}, times), do: {x + dx * times, y + dy * times}

  defp manhattan_distance({x, y}), do: abs(x) + abs(y)
end
