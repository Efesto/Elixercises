defmodule Assertions do
  def assert(:==, lhs, rhs) do
    case lhs == rhs do
      true -> IO.write(".")
      false -> IO.puts("ERROR: #{lhs} is not equal to #{rhs}")
    end
  end

  def assert(:>=, lhs, rhs) do
    case lhs >= rhs do
      true -> IO.write(".")
      false -> IO.puts("ERROR: #{lhs} is not bigger or equal to #{rhs}")
    end
  end

  defmacro assert({operation, _, [lhs, rhs]}) do
    quote bind_quoted: [lhs: lhs, rhs: rhs, operation: operation] do
      Assertions.assert(operation, lhs, rhs)
    end
  end

  defmacro __using__(_opts) do
    quote do
      import unquote(__MODULE__)
      Module.register_attribute(__MODULE__, :tests, accumulate: true)
      @before_compile unquote(__MODULE__)
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def run do
        IO.puts("Running the tests (#{inspect(@tests)})")

        Enum.each(@tests, fn {function, description} ->
          IO.puts(description)
          apply(__MODULE__, function, [])
        end)
      end
    end
  end

  defmacro test(description, do: testing_block) do
    test_func = String.to_atom(description)

    quote do
      @tests {unquote(test_func), unquote(description)}
      def unquote(test_func)(), do: unquote(testing_block)
    end
  end
end

defmodule MathTests do
  use Assertions

  test "all the numbers are the same" do
    assert 5 == 5
    assert 5 == 6
    assert 6 == 6
  end

  test "all numbers are big" do
    assert 5 >= 6
    assert 6 >= 6
    assert 5 >= 3
  end
end
