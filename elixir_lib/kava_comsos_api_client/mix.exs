defmodule KavaComsosApiClient.MixProject do
  use Mix.Project

  def project do
    [
      app: :kava_comsos_api_client,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp package() do
    [
      name: "kavaCosmosApiClient",
      description: "low level client for making a subset of
      requests to a Kava Network's Node Cosmos JSON-RPC",
      licenses: ["MIT"],
      links: []
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:req, "~> 0.4.0"},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false},
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
