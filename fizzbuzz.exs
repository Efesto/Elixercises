defmodule FizzBuzz do
  def fizz_buzz(n) do
    fizz_buzz_reducer = fn 
      {0,0,_} -> "FizzBuzz"
      {_,0,_} -> "Buzz"
      {0,_,_} -> "Fizz"
      {_,_,c} -> c
    end

    fizz_buzz_reducer.({rem(n, 3), rem(n,5), n})
   end
end