defmodule Day7 do
  @behaviour Solution

  @rule_pattern ~r/(?<color>.*?) bags contain (?<children>.*)./
  @children_pattern ~r/(?<count>\d+) (?<color>.*) bags?/

  @test_input """
  light red bags contain 1 bright white bag, 2 muted yellow bags.
  dark orange bags contain 3 bright white bags, 4 muted yellow bags.
  bright white bags contain 1 shiny gold bag.
  muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
  shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
  dark olive bags contain 3 faded blue bags, 4 dotted black bags.
  vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
  faded blue bags contain no other bags.
  dotted black bags contain no other bags.
  """

  @nested_test_input """
  shiny gold bags contain 2 dark red bags.
  dark red bags contain 2 dark orange bags.
  dark orange bags contain 2 dark yellow bags.
  dark yellow bags contain 2 dark green bags.
  dark green bags contain 2 dark blue bags.
  dark blue bags contain 2 dark violet bags.
  dark violet bags contain no other bags.
  """

  @doc """
  iex> solve_part_1(#{inspect(@test_input)})
  4
  """
  def solve_part_1(input) do
    input
    |> rules()
    |> parents("shiny gold")
    |> MapSet.size()
  end

  @doc """
  iex> solve_part_2(#{inspect(@test_input)})
  32

  iex> solve_part_2(#{inspect(@nested_test_input)})
  126
  """
  def solve_part_2(input) do
    input
    |> rules()
    |> child_count("shiny gold")
  end

  defp rules(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&Regex.named_captures(@rule_pattern, &1))
    |> Map.new(fn
      %{"color" => color, "children" => "no other bags"} -> {color, %{}}
      %{"color" => color, "children" => children} -> {color, rule_children(children)}
    end)
  end

  defp rule_children(children) do
    children
    |> String.split(", ")
    |> Enum.map(&Regex.named_captures(@children_pattern, &1))
    |> Map.new(&{&1["color"], String.to_integer(&1["count"])})
  end

  defp parents(rules, color) do
    rules
    |> Enum.filter(fn {_color, children} -> Map.has_key?(children, color) end)
    |> Enum.map(&elem(&1, 0))
    |> Enum.map(fn parent -> rules |> parents(parent) |> MapSet.put(parent) end)
    |> Enum.reduce(MapSet.new(), &MapSet.union/2)
  end

  defp child_count(rules, color) do
    rules
    |> Map.get(color)
    |> Enum.map(fn {color, count} -> count + count * child_count(rules, color) end)
    |> Enum.sum()
  end
end
