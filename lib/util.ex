defmodule Util do
  @doc """
  Generate all combinations of length `choose` as a `Stream`.
  """
  def combinations(enumerable, choose), do: combinations(enumerable, choose, [])

  defp combinations(_enumerable, 0, combination), do: [combination]

  defp combinations(enumerable, choose, combination) do
    Stream.transform(0..(length(enumerable) - choose), enumerable, fn _, [element | rest] ->
      {combinations(rest, choose - 1, [element | combination]), rest}
    end)
  end

  @doc """
  Generate all subsequences of length 2 and greater as a `Stream`.
  """
  def subsequences(enumerable) do
    Stream.flat_map(2..length(enumerable), fn length ->
      Stream.transform(0..(length(enumerable) - length), enumerable, fn _, enumerable ->
        {[Enum.take(enumerable, length)], tl(enumerable)}
      end)
    end)
  end
end
