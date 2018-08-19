defmodule SimpleProcess do
  import :timer, only: [sleep: 1]

  def spawn_processes do
    self_pid = self()
    send(spawn(Processes, :pong, [self_pid]), "Betty")
    send(spawn(Processes, :pong, [self_pid]), "Fred")

    wait_response()
    wait_response()
  end

  def wait_response do
    receive do
      token ->
        IO.puts("#{inspect(token)} received back")
    end
  end

  def pong(pid) do
    receive do
      token ->
        sleep(String.length(token) * 1000)
        send(pid, token)
    end
  end
end

defmodule LinkedProcesses do
  import :timer, only: [sleep: 1]

  def run do
    spawn_link(LinkedProcesses, :reply, [self()])
    sleep(500)

    receive do
      msg -> IO.puts(inspect(msg))
    end
  end

  def reply(parent_pid) do
    send(parent_pid, "hello!")
    # exit(:ok)
  end
end
