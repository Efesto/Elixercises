defmodule Ticker do
  @interval 2000
  @name :ticker

  def start do
    pid = spawn(__MODULE__, :generator, [[], []])
    :global.register_name(@name, pid)
  end

  def register(client_pid) do
    send(:global.whereis_name(@name), {:register, client_pid})
  end

  def generator([], []) do
    receive do
      {:register, pid} ->
        IO.puts("registering #{inspect(pid)}")
        generator([pid], [pid])
    end
  end

  def generator(clients, []) when clients != [] do
    generator(clients, clients)
  end

  def generator(clients, remaining_clients) do
    receive do
      {:register, pid} ->
        IO.puts("registering #{inspect(pid)}")
        generator([pid | clients], remaining_clients)
    after
      @interval ->
        IO.puts("Tick")
        [last_client | others] = remaining_clients
        send_tick(last_client)
        generator(clients, others)
    end
  end

  def send_tick(pid) do
    send(pid, {:tick})
  end
end

defmodule Ticker.Client do
  def start do
    pid = spawn(__MODULE__, :listen, [])
    Ticker.register(pid)
  end

  def listen do
    receive do
      {:tick} ->
        IO.puts("Tock")
        listen()
    end
  end
end
