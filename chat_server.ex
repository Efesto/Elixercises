defmodule ChatServer do
  use GenServer

  @name "host-#{:rand.uniform(50)}"

  def init(_) do
    {:ok, []}
  end

  def receiver_pid(name) do
    :global.whereis_name(name)
  end

  def send(message) do
    Enum.each(senders(), fn pid ->
      GenServer.cast(pid, {:send, message})
    end)
  end

  def register(receiver_name) do
    receiver_pid = GenServer.call(receiver_pid(receiver_name), {:register, receiver_pid(@name)})
    GenServer.call(receiver_pid(@name), {:register, receiver_pid})
  end

  def senders() do
    GenServer.call(receiver_pid(@name), :senders)
  end

  def start_link() do
    {:ok, pid} = GenServer.start_link(__MODULE__, nil, [])

    IO.puts "Client registered as #{@name}"
    :global.register_name(@name, pid)
  end

  def handle_cast({:send, message}, whatever) do
    IO.puts message
    {:noreply, whatever}
  end

  def handle_call({:register, sender_pid}, _stuff, sender_pids) do
    {:reply, self(), [sender_pid | sender_pids]}
  end

  def handle_call(:senders, _stuff, sender_pids) do
    {:reply, sender_pids, sender_pids}
  end
end
