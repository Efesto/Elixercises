defmodule DirtyCode do
  defmacro set_in_caller_context(value) do
    quote do
      var!(name) = unquote(value)
      IO.puts("set_in_caller_context")
    end
  end

  defmacro set_in_macro_context(value) do
    quote do
      name = unquote(value)
      IO.puts("set_in_macro_context")
    end
  end
end

defmodule VictimCode do
  require DirtyCode

  name = "Peter"
  DirtyCode.set_in_macro_context("Robert")
  IO.puts(name)
  DirtyCode.set_in_caller_context("Frank")
  IO.puts(name)
end
