defmodule MemoryServer do
  use GenServer

  def init(_) do
    { :ok, "empty" }
  end

  def remember(pid, word) do
    GenServer.cast(pid, {:remember, word})
  end

  def tell_me(pid) do
    GenServer.call(pid, :memory)
  end

  def start_link() do
    GenServer.start_link(__MODULE__, nil, [debug: [:trace]])
  end

  def handle_call(:memory, _from, memory) do
    {:reply, memory, memory}
  end

  def handle_cast({:remember, new_word}, _memory) do
    {:noreply, new_word}
  end
end
