


defmodule Consumer do
  use GenServer


  def start(registry_name, name, queue) do
    GenServer.start(__MODULE__, [queue: queue, name: name, registry_name: registry_name], [name: name])
  end

  def init(opts) do
    queue = Keyword.get(opts, :queue)
    name = Keyword.get(opts, :name)
    registry_name = Keyword.get(opts, :registry_name)

    Registry.register(registry_name, queue, name)

    {:ok, %{name: name}}
  end

  def handle_call(:say_hello, _, state) do
    {:reply, "Hi!, my name is #{state.name}", state}
  end

  def handle_cast(:terminate, state) do
    {:stop, :requested, state}
  end
end


defmodule Monitoring do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, [], [name: __MODULE__])
  end

  def init(_opts) do
    {:ok, nil}
  end

  def handle_info(message, state) do
    IO.inspect(message)

    {:noreply, state}
  end
end

defmodule Queue do
  def start_link(registry_name) do
      Monitoring.start_link()

      Registry.start_link(
        keys: :duplicate, # this tells the registry that is allowed to register multiple processes on the same key
        name: registry_name,
        partitions: System.schedulers_online(),
        listeners: [Monitoring]
      )
  end

  def dispatch_hello(registry_name, queue_name) do
    Registry.dispatch(registry_name, queue_name, fn entries ->
      for {pid, _} <- entries, do: IO.inspect(GenServer.call(pid, :say_hello))
    end)
  end
end

registry_name = Registry.PubSubTest
queue_name = "consumers"
Queue.start_link(registry_name)

{:ok, _consumer1} = Consumer.start(registry_name, :consumer1, queue_name)
{:ok, consumer2} = Consumer.start(registry_name, :consumer2, queue_name)

Queue.dispatch_hello(registry_name, queue_name)

GenServer.cast(consumer2, :terminate)
