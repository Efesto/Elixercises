defmodule Assertions do
  def assert(:==, lhs, rhs) do
    case lhs == rhs do
      true ->
        IO.write("\e[32m.\e[0m")

      false ->
        IO.write("\e[31mf\e[0m")
    end
  end

  def assert(:>=, lhs, rhs) do
    case lhs >= rhs do
      true ->
        IO.write("\e[32m.\e[0m")

      false ->
        IO.write("\e[31mf\e[0m")
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
      Module.register_attribute(__MODULE__, :async_tests, accumulate: true)

      @before_compile unquote(__MODULE__)
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def run do
        IO.puts("Running tests (#{Enum.count(@tests)})")

        Enum.each(@tests, fn {function, description} ->
          IO.puts("\e[1m|> #{description}\e[0m")
          apply(__MODULE__, function, [])
        end)
      end

      def parallel_run do
        IO.puts("Running tests in parallel(#{Enum.count(@async_tests)})")

        Enum.each(@async_tests, fn {function, description} ->
          Task.start(fn ->
            IO.puts("\e[1m|> #{description}\e[0m")
            apply(__MODULE__, function, [])
          end)
        end)
      end
    end
  end

  defmacro test(description, do: testing_block) do
    test_func = String.to_atom(description)

    quote do
      @tests {unquote(test_func), unquote(description)}

      def unquote(test_func)() do
        unquote(testing_block)
        IO.puts("")
      end
    end
  end

  defmacro test(description, [async: true], do: testing_block) do
    test_func = String.to_atom(description)

    quote do
      @async_tests {unquote(test_func), unquote(description)}
      test(unquote(description), do: unquote(testing_block))
    end
  end
end

defmodule MathTests do
  use Assertions

  test "all the numbers are the same", async: true do
    assert 5 == 5
    assert 5 == 6
    assert 6 == 6
  end

  test "all numbers are big", async: true do
    assert 5 >= 6
    assert 6 >= 6
    assert 5 >= 3
  end
end
