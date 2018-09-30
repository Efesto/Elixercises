defmodule Sigils do
  def sigil_v(input, _) do
    input
    |> String.split("\n")
    |> Enum.map(
      &(String.split(&1, ",")
        |> Enum.map(fn s -> convert_floats(s) end))
    )
  end

  defp convert_floats(string, :error) do
    string
  end

  defp convert_floats(string, {parsed, _}) do
    parsed
  end

  defp convert_floats(string) do
    convert_floats(string, Float.parse(string))
  end
end
