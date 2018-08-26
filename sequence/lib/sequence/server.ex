defmodule Sequence.Server do
  # This adds the GenServer behavior
  use GenServer

  def init(_) do
    {:ok, Sequence.Stash.get()}
  end

  def start_link(current_number) do
    GenServer.start_link(__MODULE__, current_number, name: __MODULE__)
  end

  def increment_number(delta) do
    GenServer.cast(__MODULE__, {:increment_number, delta})
  end

  def next_number do
    GenServer.call(__MODULE__, :next_number)
  end

  def terminate(_reason, current_number) do
    Sequence.Stash.put(current_number)
  end

  # This is like recurring on the server listening call by sending the new state
  def handle_call(:next_number, _from, current_number) do
    {:reply, current_number, current_number + 1}
  end

  def handle_cast({:increment_number, delta}, current_number) do
    {:noreply, current_number + delta}
  end

  def format_status(_reason, [_pdict, state]) do
    [data: [{'State', "I am in #{inspect(state)}"}]]
  end
end
