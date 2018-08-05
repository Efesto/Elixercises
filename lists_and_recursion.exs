defmodule ListsAndRecursion do
  def mapsum([], func), do: 0
  def mapsum([head | tail], func) do
   func.(head) + mapsum(tail, func)
  end

  def my_max([], max), do: max
  def my_max([head | tail], max) do
    my_max(tail, (if (max && max > head), do: max, else: head))
  end
  def my_max(list), do: my_max(list, nil)

  def caesar([], n), do: []
  def caesar([head | tail], n), do: [ head + n | caesar(tail, n) ]

  def span(from, from), do: [from] 
  def span(from, to), do: [from | span(from + 1, to)]

  def my_all?([a], func), do: func.(a) 
  def my_all?([head | tail], func) do
    func.(head) && my_all?(tail, func)
  end

  def my_each([a], func), do: [func.(a)]
  def my_each([head|tail], func) do
    [func.(head) | my_each(tail, func)]
  end
end