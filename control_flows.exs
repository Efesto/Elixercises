defmodule ControlFlows do
  def fizz_buzz(n) do
    1..n |> 
      Enum.map(
        fn x ->
          case {rem(x, 3), rem(x, 5)} do
            {0,0} -> "FizzBuzz"
            {0,_} -> "Fizz"
            {_,0} -> "Buzz"
            _ -> x
          end
        end
      )
  end

  def ok!({:ok, data}), do: data
  def ok!({_, data}), do: raise data
end