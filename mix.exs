defmodule MercuryOxide.MixProject do
  use Mix.Project

  def project do
    [
      app: :mercury_oxide,
      version: "0.2.0",
      elixir: ">= 1.12.0",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      compilers: [:rustler] ++ Mix.compilers(),
      rustler_crates: rustler_crates(),
      package: package(),
      name: "MercuryOxide",
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
      {:rustler, "~> 0.23.0"},
      {:ex_doc, ">= 0.1.0", only: :dev, runtime: false}
    ]
  end

  defp rustler_crates do
    [
      mercury_oxide: [
        path: "native/mercury_oxide",
        mode: rust_mode(Mix.env()),
        features: []
      ]
    ]
  end

  defp package do
    [
      description: "Renders Liquid templates using Liquid-Rust",
      licenses: ["Unlicense"],
      files: [
        "lib",
        "native/mercury_oxide/.cargo",
        "native/mercury_oxide/Cargo.*",
        "native/mercury_oxide/src",
        "mix.exs",
        "README.md",
        "LICENSE"
      ],
      links: %{"Github" => "https://github.com/thomas9911/mercury_oxide_elixir"}
    ]
  end

  defp rust_mode(:prod), do: :release
  defp rust_mode(_), do: :debug
end
