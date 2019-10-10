# https://elixir-lang.org/getting-started/processes.html
# This spawns processes and waits for their response

defmodule Process do
  import :timer, only: [sleep: 1]

  def spawn_processes do
    self_pid = self()
    send(spawn(Process, :pong, [self_pid]), "Betty")
    send(spawn(Process, :pong, [self_pid]), "Fred")

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
