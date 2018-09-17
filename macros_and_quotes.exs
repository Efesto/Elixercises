defmodule Test do
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
  require Test
  Test.times_n(3)
  Test.times_n(4)
end
