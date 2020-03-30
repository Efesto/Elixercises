defmodule SimpleQueue do
  use GenServer

  @doc """
  Start our queue and link it.
  This is a helper function
  """
  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @doc """
  GenServer.init/1 callback
  """
  def init(state), do: {:ok, state}

  def handle_call(:dequeue, _from, [value | state]), do: {:reply, value, state}
  def handle_call(:dequeue, _from, []), do: {:reply, nil, []}

  def handle_call(:queue, _from, state), do: {:reply, state, state}

  def handle_cast({:enqueue, value}, state), do: {:noreply, state ++ [value]}

  def queue, do: GenServer.call(__MODULE__, :queue)
  def dequeue, do: GenServer.call(__MODULE__, :dequeue)
  def enqueue(value), do: GenServer.cast(__MODULE__, {:enqueue, value})
end
