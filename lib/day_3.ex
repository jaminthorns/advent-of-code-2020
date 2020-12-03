defmodule Day3 do
  @behaviour Solution

  @test_input """
  ..##.......
  #...#...#..
  .#....#..#.
  ..#.#...#.#
  .#...##..#.
  ..#.##.....
  .#.#.#....#
  .#........#
  #.##...#...
  #...##....#
  .#..#...#.#
  """

  @doc """
  iex> solve_part_1(#{inspect(@test_input)})
  7
  """
  def solve_part_1(input) do
    input
    |> grid()
    |> trees_along_slope(3, 1)
  end

  @doc """
  iex> solve_part_2(#{inspect(@test_input)})
  336
  """
  def solve_part_2(input) do
    grid = grid(input)

    [{1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}]
    |> Enum.map(fn {dx, dy} -> trees_along_slope(grid, dx, dy) end)
    |> Enum.reduce(&Kernel.*/2)
  end

  defp grid(input) do
    rows =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&String.graphemes/1)

    spaces =
      for {row, y} <- Enum.with_index(rows),
          {symbol, x} <- Enum.with_index(row),
          into: %{} do
        {{x, y}, object(symbol)}
      end

    height = length(rows)
    width = rows |> List.first() |> length()

    %{spaces: spaces, height: height, width: width}
  end

  defp object("."), do: :open
  defp object("#"), do: :tree

  defp trees_along_slope(grid, dx, dy, position \\ {0, 0}, trees \\ 0) do
    trees = if grid.spaces[position] == :tree, do: trees + 1, else: trees
    {_, y} = next_position = position |> add_position(dx, dy) |> normalize_position(grid)

    if y >= grid.height do
      trees
    else
      trees_along_slope(grid, dx, dy, next_position, trees)
    end
  end

  defp add_position({x, y}, dx, dy), do: {x + dx, y + dy}

  defp normalize_position({x, y}, grid), do: {rem(x, grid.width), y}
end
