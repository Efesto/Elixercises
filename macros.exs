# Macros definitions and runtime defined functions

defmodule Macros do
  defmacro times_n(n) do
    quote do
      def unquote(:"times_#{n}")(param) do
        unquote(n) * param
      end
    end
  end

  defmacro myunless(condition, clauses) do
    do_clause = Keyword.get(clauses, :do)
    else_clause = Keyword.get(clauses, :else)

    quote do
      if unquote(condition) do
        unquote(else_clause)
      else
        unquote(do_clause)
      end
    end
  end
end

defmodule User do
  require Macros
  Macros.times_n(3)
  Macros.times_n(4)
end

# Custom unless function
Enum.each(
  1..5,
  fn x ->
    IO.puts x
    Macros.myunless(rem(x, 2) == 0)
      do
      IO.puts "odd"
    else
      IO.puts "even"
    end
  end
)
