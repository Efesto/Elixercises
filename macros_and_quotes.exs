defmodule Times do
  defmacro times_n(n) do
    quote do
      def unquote(:"times_#{n}")(param) do
        unquote(n) * param
      end
    end
  end
end

defmodule Test do
  require Times
  Times.times_n(3)
  Times.times_n(4)
end
