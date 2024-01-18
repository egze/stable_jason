defmodule StableJason.MixProject do
  use Mix.Project

  @version "1.0.0"
  @source_url "https://github.com/egze/stable_jason"

  def project do
    [
      app: :stable_jason,
      version: @version,
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      docs: docs()
    ]
  end

  def application do
    []
  end

  defp description do
    """
    StableJason is a library for encoding Elixir values to a stable JSON with deterministic sorting for keys.
    """
  end

  defp package() do
    [
      maintainers: ["Aleksandr Lossenko"],
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => @source_url}
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.31.1", only: :dev, runtime: false},
      {:jason, "~> 1.3"}
    ]
  end

  defp docs() do
    [
      main: "readme",
      name: "StableJason",
      source_ref: "v#{@version}",
      canonical: "http://hexdocs.pm/stable_jason",
      source_url: @source_url,
      extras: ["README.md", "CHANGELOG.md", "LICENSE"]
    ]
  end
end
