defmodule Enigma do
  @external_resource enigma_code_path = Path.join([__DIR__, "enigma.txt"])

  for line <- File.stream!(enigma_code_path, [], :line) do
    [code1, code2] = line |> String.split(" ") |> Enum.map(&String.strip(&1))

    def encode(unquote(code1) <> rest), do: unquote(code2) <> encode(rest)
    def decode(unquote(code2) <> rest), do: unquote(code1) <> decode(rest)
  end

  def encode(_code), do: ""
  def decode(_code), do: ""
end

# TODO: How to inspect methods of Enigma?
