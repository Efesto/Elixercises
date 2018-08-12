defmodule StringsAndBinaries do
  def ascii_only?([]), do: true
  def ascii_only?([head|tail]), do: head >= ?\s && head <= ?~ && ascii_only?(tail) 
  
  def anagram?(word1, word2), do: (length(word1 -- word2) + length(word2 -- word1)) == 0

  def center(words) do
    print = fn(word, max_size) ->
      padding_trailing = String.length(word) + div(max_size - String.length(word), 2) 
      IO.puts(String.pad_trailing(String.pad_leading(word, padding_trailing), max_size))
    end

    lengths = Enum.map(words, &(String.length(&1)))
    biggest_length = Enum.max lengths

    Enum.each words, &(print.(&1, biggest_length))
  end
end