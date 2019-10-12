defmodule ChatServer do
  use GenServer

  def start(host_name) do
    {:ok, _pid} = GenServer.start_link(__MODULE__, nil, name: {:global, host_name})

    IO.puts("Client registered as #{host_name}")
  end

  def init(_) do
    {:ok, []}
  end

  def receiver_pid(name) do
    :global.whereis_name(name)
  end

  def handle_call({:message, message}, {sender_pid, _}, senders) do
    {_, sender_name} = Enum.find(senders, {nil, "Anon"}, fn {pid, _} -> pid == sender_pid end)

    IO.puts("#{sender_name}: #{message}")
    {:reply, :ok, senders}
  end

  def handle_call({:register, {node_name, sender_pid}}, _stuff, senders) do
    {:reply, {self(), Node.self()}, [{node_name, sender_pid} | senders]}
  end

  def handle_call(:senders, _stuff, senders) do
    {:reply, senders, senders}
  end

  def handle_cast({:send, message}, senders) do
    Enum.each(senders, fn {pid, _} -> GenServer.call(pid, {:message, message}) end)
    {:noreply, senders}
  end
end
