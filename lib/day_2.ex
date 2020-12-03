defmodule Day2 do
  @behaviour Solution

  @test_input """
  1-3 a: abcde
  1-3 b: cdefg
  2-9 c: ccccccccc
  """

  @password_pattern ~r/(?<num_a>\d+)-(?<num_b>\d+) (?<letter>[a-z]): (?<password>\w+)/

  @doc """
  iex> solve_part_1(#{inspect(@test_input)})
  2
  """
  def solve_part_1(input) do
    input
    |> passwords()
    |> Enum.count(&password_valid_range?/1)
  end

  @doc """
  iex> solve_part_2(#{inspect(@test_input)})
  1
  """
  def solve_part_2(input) do
    input
    |> passwords()
    |> Enum.count(&password_valid_positions?/1)
  end

  defp passwords(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&Regex.named_captures(@password_pattern, &1))
    |> Enum.map(fn entry ->
      %{
        num_a: String.to_integer(entry["num_a"]),
        num_b: String.to_integer(entry["num_b"]),
        letter: entry["letter"],
        password: entry["password"]
      }
    end)
  end

  defp password_valid_range?(entry) do
    count =
      entry.password
      |> String.graphemes()
      |> Enum.count(&(&1 == entry.letter))

    count in entry.num_a..entry.num_b
  end

  defp password_valid_positions?(entry) do
    letter_a = String.at(entry.password, entry.num_a - 1)
    letter_b = String.at(entry.password, entry.num_b - 1)

    entry.letter in [letter_a, letter_b] and letter_a != letter_b
  end
end
