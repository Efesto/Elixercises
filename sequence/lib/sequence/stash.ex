defmodule Sequence.Stash do
  use GenServer
  @name __MODULE__

  def start_link(initial_value) do
    GenServer.start_link(__MODULE__, initial_value, [debug: [:trace], name: @name])
  end

  def get do
    GenServer.call(@name, :get)
  end

  def put(number) do
    GenServer.cast(@name, {:put, number})
  end

  def init(initial_number) do
    {:ok, initial_number}
  end

  def handle_cast({:put, number}, _current_number) do
    {:noreply, number}
  end

  def handle_call(:get, _from, current_number) do
    {:reply, current_number, current_number}
  end
end
