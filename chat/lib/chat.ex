defmodule Chat do
  require ChatServer

  def receiver_pid(name) do
    :global.whereis_name(name)
  end

  def send(message) do
    GenServer.cast(local_server(), {:send, message})
  end

  def register(receiver_name) do
    Node.connect(receiver_name)

    # TODO: this needs something because receiver_pid(receiver_name) returns nil at the first call
    response =
      GenServer.call(
        receiver_pid(receiver_name),
        {:register, {local_server(), local_server_name()}}
      )

    GenServer.call(local_server(), {:register, response})
  end

  def senders() do
    GenServer.call(local_server(), :senders)
  end

  def start_server() do
    ChatServer.start(local_server_name())
  end

  def local_server() do
    receiver_pid(local_server_name())
  end

  def local_server_name() do
    Node.self()
  end
end
