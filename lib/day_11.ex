defmodule Day11 do
  @behaviour Solution

  @test_input """
  L.LL.LL.LL
  LLLLLLL.LL
  L.L.L..L..
  LLLL.LL.LL
  L.LL.LL.LL
  L.LLLLL.LL
  ..L.L.....
  LLLLLLLLLL
  L.LLLLLL.L
  L.LLLLL.LL
  """

  @directions List.delete(for(x <- -1..1, y <- -1..1, do: {x, y}), {0, 0})

  @doc """
  iex> solve_part_1(#{inspect(@test_input)})
  37
  """
  def solve_part_1(input) do
    input
    |> waiting_area()
    |> occupied_at_equilibrium(4, &adjacent/2)
  end

  @doc """
  iex> solve_part_2(#{inspect(@test_input)})
  26
  """
  def solve_part_2(input) do
    input
    |> waiting_area()
    |> occupied_at_equilibrium(5, &first_seen/2)
  end

  defp waiting_area(input) do
    for {line, y} <- input |> String.split() |> Enum.with_index(),
        {symbol, x} <- line |> String.graphemes() |> Enum.with_index(),
        into: %{} do
      {{x, y}, state(symbol)}
    end
  end

  defp state("."), do: :floor
  defp state("L"), do: :empty
  defp state("#"), do: :occupied

  defp occupied_at_equilibrium(waiting_area, tolerance, neighbors) do
    waiting_area
    |> Stream.iterate(&step(&1, tolerance, neighbors))
    |> Stream.scan({nil, nil}, fn curr, {prev, _} -> {curr, prev} end)
    |> Enum.find(fn {curr, prev} -> curr == prev end)
    |> elem(0)
    |> occupied()
  end

  defp step(waiting_area, tolerance, neighbors) do
    Map.new(waiting_area, fn {position, state} ->
      neighbors = neighbors.(position, waiting_area)
      occupied = waiting_area |> Map.take(neighbors) |> occupied()

      cond do
        state == :empty and occupied == 0 -> {position, :occupied}
        state == :occupied and occupied >= tolerance -> {position, :empty}
        true -> {position, state}
      end
    end)
  end

  defp occupied(waiting_area) do
    waiting_area
    |> Map.values()
    |> Enum.frequencies()
    |> Map.get(:occupied, 0)
  end

  defp adjacent({x, y}, _waiting_area) do
    Enum.map(@directions, fn {dx, dy} -> {x + dx, y + dy} end)
  end

  defp first_seen({x, y}, waiting_area) do
    Enum.map(@directions, fn {dx, dy} ->
      1
      |> Stream.iterate(&(&1 + 1))
      |> Stream.map(&{x + dx * &1, y + dy * &1})
      |> Enum.find(&(Map.get(waiting_area, &1) != :floor))
    end)
  end
end
