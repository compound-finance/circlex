defmodule Circlex.MixProject do
  use Mix.Project

  def project do
    [
      app: :circlex_api,
      version: "0.1.5",
      elixir: "~> 1.13",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      name: "Circlex",
      description: "Circle API Client and Emulator",
      source_url: "https://github.com/compound-finance/circlex",
      docs: [
        main: "readme",
        extras: ["README.md", "LICENSE.md"]
      ],
      package: package()
    ]
  end

  defp package() do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Geoffrey Hayes"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/compound-finance/circlex"}
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
  defp elixirc_paths(:test), do: ["lib", "test/support", "deps/signet/test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.27", only: :dev, runtime: false},
      {:signet, "~> 0.1.8"},
      {:plug_cowboy, "~> 2.5"},
      {:jason, "~> 1.2"},
      {:httpoison, "~> 1.8"},
      {:uuid, "~> 1.1"},
      {:decimal, "~> 2.0", only: [:test, :dev]},
      {:junit_formatter, "~> 3.1", only: [:test]}
    ]
  end
end
