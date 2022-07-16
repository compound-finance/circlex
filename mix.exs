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

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:signet, path: "../signet"},
      {:plug_cowboy, "~> 2.5"},
      {:jason, "~> 1.2"},
      {:httpoison, "~> 1.8"}
    ]
  end
end
