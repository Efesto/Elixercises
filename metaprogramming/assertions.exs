defmodule Assertions do
  defmacro assert({:==, _, [lhs, rhs]}) do
    quote bind_quoted: [lhs: lhs, rhs: rhs] do
      case lhs == rhs do
        true -> :ok
        false -> {:error, "#{lhs} is not equal to #{rhs}"}
      end
    end
  end
end
