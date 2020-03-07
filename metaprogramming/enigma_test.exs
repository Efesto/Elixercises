ExUnit.start()
Code.require_file("enigma.exs", __DIR__)

defmodule EnigmaTest do
  use ExUnit.Case

  describe "decode/1" do
    test "returns empty for unknown chars" do
      assert Enigma.decode("zZz") == ""
    end

    test "returns decoding based on config file" do
      assert Enigma.decode("EFG") == "DEF"
    end
  end
end
