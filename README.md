# MercuryOxide
## a NIF for Liquid-Rust

MercuryOxide a Rusty Liquid

## To build:
Have rust and cargo installed


## Installation

The package can be installed by adding `mercury_oxide` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:mercury_oxide, "~> 0.1.0"}
  ]
end
```

The docs can be found at [https://hexdocs.pm/mercury_oxide](https://hexdocs.pm/mercury_oxide).

## Examples

```
iex> MercuryOxide.render("Hello {{ name | capitalize }}", name: "person")
{:ok, "Hello Person"}
```

```
iex> partial = "Hello {{ name | capitalize }}"
...> MercuryOxide.render("{% include 'greeting' %}, what a nice day", [name: "person"], [greeting: partial])
{:ok, "Hello Person, what a nice day"}
```
