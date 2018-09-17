defmodule TestBehaviours do
  defmacro def(definition = {name, _, _}, do: content) do
    quote do
      Kernel.def unquote(definition) do
        IO.puts("calling def #{unquote(name)}")
        unquote(content)
      end
    end
  end

  defmacro __using__(_opts) do
    quote do
      import Kernel, except: [def: 2]
      import unquote(__MODULE__), only: [def: 2]
    end
  end
end
