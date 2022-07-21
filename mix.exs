defmodule Circlex.MixProject do
  use Mix.Project

  def project do
    [
      app: :circlex,
      version: "0.1.0",
      elixir: "~> 1.13",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Circlex.Application, []},
      extra_applications: [:logger]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:signet, "~> 0.1.0-rc7"},
      {:plug_cowboy, "~> 2.5"},
      {:jason, "~> 1.2"},
      {:httpoison, "~> 1.8"},
      {:uuid, "~> 1.1"},
      {:decimal, "~> 2.0", only: [:test, :dev]}
    ]
  end
end
