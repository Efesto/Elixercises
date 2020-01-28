defmodule RawSum do
  defmacro raw_sum(term1, term2) do
    {:+, [], [term1, term2]}
  end

  defmacro sum(term1, term2) do
    quote do
      unquote(term1) + unquote(term2)
    end
  end

  # raw_sum and sum are the same
end

# Elixir expands macros in code evaluation end executes the returned AST as quoted code
# (That's why we usually start a macro with `quote`)
