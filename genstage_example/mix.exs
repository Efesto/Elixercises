defmodule GenstageExample.MixProject do
  use Mix.Project

  def project do
    [
      app: :genstage_example,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {GenstageExample.Application, []}
    ]
  end

  defp deps do
    [
      {:gen_stage, "~> 1.0.0"}
    ]
  end
end
