defmodule GenstageExample.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  alias GenstageExample.{Producer, Consumer, ProducerConsumer}

  def start(_type, _args) do
    children = [
      {Producer, 0},
      {ProducerConsumer, []},
      {Consumer, []}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GenstageExample.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
