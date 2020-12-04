defmodule Day4 do
  @behaviour Solution

  @required_fields ~w(byr iyr eyr hgt hcl ecl pid)

  @test_input """
  ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
  byr:1937 iyr:2017 cid:147 hgt:183cm

  iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
  hcl:#cfa07d byr:1929

  hcl:#ae17e1 iyr:2013
  eyr:2024
  ecl:brn pid:760753108 byr:1931
  hgt:179cm

  hcl:#cfa07d eyr:2025 pid:166559648
  iyr:2011 ecl:brn hgt:59in
  """

  @doc """
  iex> solve_part_1(#{inspect(@test_input)})
  2
  """
  def solve_part_1(input) do
    input
    |> passports()
    |> Enum.count(&has_all_fields?/1)
  end

  @test_input_invalid """
  eyr:1972 cid:100
  hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926

  iyr:2019
  hcl:#602927 eyr:1967 hgt:170cm
  ecl:grn pid:012533040 byr:1946

  hcl:dab227 iyr:2012
  ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277

  hgt:59cm ecl:zzz
  eyr:2038 hcl:74454a iyr:2023
  pid:3556412378 byr:2007
  """

  @test_input_valid """
  pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980
  hcl:#623a2f

  eyr:2029 ecl:blu cid:129 byr:1989
  iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm

  hcl:#888785
  hgt:164cm byr:2001 iyr:2015 cid:88
  pid:545766238 ecl:hzl
  eyr:2022

  iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719
  """

  @doc """
  iex> solve_part_2(#{inspect(@test_input_invalid)})
  0

  iex> solve_part_2(#{inspect(@test_input_valid)})
  4
  """
  def solve_part_2(input) do
    input
    |> passports()
    |> Enum.count(&(has_all_fields?(&1) and fields_valid?(&1)))
  end

  defp passports(input) do
    input
    |> String.split("\n\n")
    |> Enum.map(fn passport ->
      passport
      |> String.split()
      |> Enum.map(&String.split(&1, ":"))
      |> Map.new(&List.to_tuple/1)
    end)
  end

  defp has_all_fields?(passport) do
    Enum.all?(@required_fields, &Map.has_key?(passport, &1))
  end

  defp fields_valid?(passport) do
    passport
    |> Map.take(@required_fields)
    |> Enum.all?(&field_valid?/1)
  end

  defp field_valid?({"byr", value}), do: String.to_integer(value) in 1920..2002
  defp field_valid?({"iyr", value}), do: String.to_integer(value) in 2010..2020
  defp field_valid?({"eyr", value}), do: String.to_integer(value) in 2020..2030

  defp field_valid?({"hgt", value}) do
    case Integer.parse(value) do
      {number, "cm"} -> number in 150..193
      {number, "in"} -> number in 59..76
      _ -> false
    end
  end

  defp field_valid?({"hcl", value}), do: String.match?(value, ~r/^#[0-9a-f]{6}$/)
  defp field_valid?({"ecl", value}), do: value in ~w(amb blu brn gry grn hzl oth)
  defp field_valid?({"pid", value}), do: String.match?(value, ~r/^[0-9]{9}$/)
end
