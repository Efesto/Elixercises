defmodule State do
  defstruct inquire_ref: nil, message_number: 0
end

defmodule PingWorker do
  use GenServer

  require Logger

  @interval 3000
  @inquire_interval @interval * 4

  def start_link() do
    {:ok, pid} = GenServer.start_link(__MODULE__, nil, name: __MODULE__)
    pid
  end

  @impl true
  def init(_opts) do
    Process.send_after(self(), :do_pong, @interval)

    {:ok, schedule_inquire(%State{})}
  end

  defp schedule_inquire(state) do
    if state.inquire_ref do
      Process.cancel_timer(state.inquire_ref)
    end

    ref = Process.send_after(self(), :where_is_my_ping?, @inquire_interval)
    %State{state | inquire_ref: ref}
  end

  @impl true
  def handle_info(:do_pong, state) do
    GenServer.cast(PongWorker, :pong)
    Process.send_after(self(), :do_pong, @interval)

    {:noreply, state}
  end

  @impl true
  def handle_info(:where_is_my_ping?, state) do
    Logger.info("#{inspect(self())} where is my ping?")

    {:noreply, schedule_inquire(state)}
  end

  @impl true
  def handle_cast(:ping, state) do
    state = %State{state | message_number: state.message_number + 1}

    Logger.info("#{inspect(self())} ping #{state.message_number}")

    {:noreply, schedule_inquire(state)}
  end
end

defmodule PongWorker do
  use GenServer

  require Logger

  @interval 2000
  @inquire_interval @interval * 4

  def start_link() do
    {:ok, pid} = GenServer.start_link(__MODULE__, nil, name: __MODULE__)
    pid
  end

  @impl true
  def init(_opts) do
    Process.send_after(self(), :do_ping, @interval)

    {:ok, schedule_inquire(%State{})}
  end

  @impl true
  def handle_info(:do_ping, state) do
    GenServer.cast(PingWorker, :ping)
    Process.send_after(self(), :do_ping, @interval)

    {:noreply, state}
  end

  @impl true
  def handle_info(:where_is_my_pong?, state) do
    Logger.info("#{inspect(self())} where is my pong?")

    {:noreply, schedule_inquire(state)}
  end

  @impl true
  def handle_cast(:pong, state) do
    state = %State{state | message_number: state.message_number + 1}

    Logger.info("#{inspect(self())} pong #{state.message_number}")

    {:noreply, schedule_inquire(state)}
  end

  defp schedule_inquire(state) do
    if state.inquire_ref do
      Process.cancel_timer(state.inquire_ref)
    end

    ref = Process.send_after(self(), :where_is_my_pong?, @inquire_interval)
    %State{state | inquire_ref: ref}
  end
end
