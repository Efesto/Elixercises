defmodule ServerTest do
  use ExUnit.Case

  test "returns value in stash as first number" do
    Sequence.Stash.put(123)
    assert Sequence.Server.next_number() == 123
  end

  test "terminate saves the last value in stash" do
    Sequence.Server.terminate(nil, 456)
    assert Sequence.Stash.get() == 456
  end
end
