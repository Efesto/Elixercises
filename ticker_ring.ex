defmodule Ticker.Client do
  @interval 2000
  @name :ticker

  def start_first do
    pid = spawn(__MODULE__, :listen, [[], []])
  end

  def start_new do
    pid = spawn(__MODULE__, :listen, [[], []])
    send(:global.whereis_name(@name), {:register, pid})
  end

  def send_tick(pid, ring, remaining) do
    send(pid, {:tick, ring, remaining})
  end

  def listen([], []) do
    listen([self()], [self()])
  end

  def listen(ring, remaining) when length(ring) == 1 do
    :global.register_name(@name, self())

    receive do
      {:register, pid} ->
        IO.puts("Register #{inspect(pid)}")
        listen([pid | ring], remaining)
    end
  end

  def listen(ring, []) when ring != [] do
    listen(ring, ring)
  end

  def listen(ring, remaining) do
    receive do
      {:tick, ring} ->
        IO.puts("Tock")
        :global.register_name(@name, self())
        listen(ring, remaining)

      {:register, pid} ->
        IO.puts("Register #{inspect(pid)}")
        listen([pid | ring], remaining)
    after
      @interval ->
        [next | others] = remaining
        send_tick(next, ring, others)
    end
  end
end
