defmodule Day7 do
  @behaviour Solution

  @rule_pattern ~r/(?<color>.*?) bags contain (?<contents>.*)./
  @contents_pattern ~r/(?<count>\d+) (?<color>.*) bags?/

  @complex_test_input """
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

  @simple_test_input """
  shiny gold bags contain 2 dark red bags.
  dark red bags contain 2 dark orange bags.
  dark orange bags contain 2 dark yellow bags.
  dark yellow bags contain 2 dark green bags.
  dark green bags contain 2 dark blue bags.
  dark blue bags contain 2 dark violet bags.
  dark violet bags contain no other bags.
  """

  @doc """
  iex> solve_part_1(#{inspect(@complex_test_input)})
  4
  """
  def solve_part_1(input) do
    input
    |> rules()
    |> containers()
    |> parent_count("shiny gold")
    |> Enum.uniq()
    |> length()
  end

  @doc """
  iex> solve_part_2(#{inspect(@complex_test_input)})
  32

  iex> solve_part_2(#{inspect(@simple_test_input)})
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
    |> Map.new(fn line ->
      rule = Regex.named_captures(@rule_pattern, line)

      contents =
        case rule["contents"] do
          "no other bags" ->
            []

          contents ->
            contents
            |> String.split(", ")
            |> Enum.map(&Regex.named_captures(@contents_pattern, &1))
            |> Enum.map(&{String.to_integer(&1["count"]), &1["color"]})
        end

      {rule["color"], contents}
    end)
  end

  defp containers(rules) do
    rules
    |> Enum.flat_map(fn {container, bags} ->
      Enum.map(bags, fn {_count, bag} -> {bag, container} end)
    end)
    |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))
  end

  defp parent_count(containers, color, colors \\ []) do
    containers
    |> Map.get(color)
    |> case do
      nil -> colors
      parents -> Enum.flat_map(parents, &parent_count(containers, &1, [&1 | colors]))
    end
  end

  defp child_count(rules, color) do
    rules
    |> Map.get(color)
    |> case do
      [] ->
        0

      children ->
        children
        |> Enum.map(fn {count, color} -> count + count * child_count(rules, color) end)
        |> Enum.sum()
    end
  end
end
