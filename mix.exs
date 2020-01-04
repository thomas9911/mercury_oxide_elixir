defmodule MercuryOxide.MixProject do
  use Mix.Project

  def project do
    [
      app: :mercury_oxide,
      version: "0.1.0",
      elixir: ">= 1.7.0",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      compilers: [:rustler] ++ Mix.compilers(),
      rustler_crates: rustler_crates(),
      docs: [
        main: "MercuryOxide",
        extra_section: []
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:rustler, "~> 0.21.0"},
      {:ex_doc, ">= 0.1.0", only: :dev, runtime: false}
    ]
  end

  defp rustler_crates do
    [
      mercury_oxide: [
        path: "native/mercury_oxide",
        mode: rust_mode(Mix.env())
      ]
    ]
  end

  defp rust_mode(:prod), do: :release
  defp rust_mode(_), do: :debug
end
