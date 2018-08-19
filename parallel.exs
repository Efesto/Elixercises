defmodule Parallel do
  def pmap(collection, func) do
    spawner_pid = self()

    collection
    |> Enum.map(fn elem ->
      spawn_link(fn -> send(spawner_pid, {self(), func.(elem)}) end)
    end)
    |> Enum.map(fn pid ->
      receive do
        {^pid, result} -> result
      end
    end)
  end
end
