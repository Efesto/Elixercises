defmodule Unless do
  defmacro unless(condition, do: do_block, else: else_block) do
    quote do
      case unquote(condition) do
        true -> unquote(else_block)
        false -> unquote(do_block)
      end
    end
  end
end
