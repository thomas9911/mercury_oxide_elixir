# MercuryOxide a NIF for Liquid-Rust

MercuryOxide a Rusty Liquid

## To build:
Have rust and cargo installed

add {:mercury_oxide, "~> 0.1.0"}

```
MercuryOxide.render("Hello {{ name }}", name: "Person")
```

```
partial = "Hello {{ name }}"
MercuryOxide.render("{% include 'greeting' %}, what a nice day", [name: "Person"], [greeting: partial])
```