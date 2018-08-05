defmodule ModulesAndFunctions do
  def sum(total, 1), do: total + 1
  def sum(total, n), do: total + n + sum(total, n-1)
  def sum(n), do: sum(0, n)
end