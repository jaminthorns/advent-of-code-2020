defmodule Day13 do
  @behaviour Solution

  @test_input """
  939
  7,13,x,x,59,x,31,19
  """

  @doc """
  iex> solve_part_1(#{inspect(@test_input)})
  295
  """
  def solve_part_1(input) do
    {arrival, bus_ids} = arrival_and_bus_ids(input)
    {bus_id, departure} = first_available_bus(arrival, bus_ids)

    (departure - arrival) * bus_id
  end

  @doc """
  iex> solve_part_2(#{inspect(@test_input)})
  1068781
  """
  def solve_part_2(input) do
    input
    |> arrival_and_bus_ids()
    |> elem(1)
    |> consecutive_bus_timestamp()
  end

  defp arrival_and_bus_ids(input) do
    [arrival, bud_ids] = String.split(input)
    bus_ids = bud_ids |> String.split(",") |> Enum.map(&bus_id/1)

    {String.to_integer(arrival), bus_ids}
  end

  defp bus_id("x"), do: :out_of_service
  defp bus_id(id), do: String.to_integer(id)

  defp first_available_bus(arrival, bus_ids) do
    bus_ids = Enum.reject(bus_ids, &(&1 == :out_of_service))

    arrival
    |> Stream.iterate(&(&1 + 1))
    |> Enum.find_value(fn departure ->
      case Enum.find(bus_ids, &(rem(departure, &1) == 0)) do
        nil -> nil
        bus_id -> {bus_id, departure}
      end
    end)
  end

  defp consecutive_bus_timestamp(bus_ids) do
    bus_ids
    |> Enum.with_index()
    |> Enum.reject(fn {id, _} -> id == :out_of_service end)
    |> Enum.map(fn {bus_id, offset} -> {bus_id, bus_id - offset} end)
    |> chinese_remainder_theorem()
  end

  defp chinese_remainder_theorem(pairs) do
    mod_product = pairs |> Enum.map(&elem(&1, 0)) |> Enum.reduce(&Kernel.*/2)

    pairs
    |> Enum.map(fn {mod, rem} ->
      other_mod_product = div(mod_product, mod)
      rem * other_mod_product * mod_inverse(other_mod_product, mod)
    end)
    |> Enum.sum()
    |> rem(mod_product)
  end

  defp mod_inverse(number, mod) do
    number = rem(number, mod)

    1
    |> Stream.iterate(&(&1 + 1))
    |> Enum.find(&(rem(number * &1, mod) == 1))
  end
end
