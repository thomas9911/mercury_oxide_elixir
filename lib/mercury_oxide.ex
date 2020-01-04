defmodule MercuryOxide do
  @moduledoc """
  MercuryOxide a Rusty Liquid.

  Renders Liquid templates using [Liquid](https://github.com/cobalt-org/liquid-rust)

  Examples:

  ```
  iex> MercuryOxide.render("Hello {{ name | capitalize }}", name: "person")
  {:ok, "Hello Person"}
  ```

  ```
  iex> partial = "Hello {{ name | capitalize }}"
  ...> MercuryOxide.render("{% include 'greeting' %}, what a nice day", [name: "person"], [greeting: partial])
  {:ok, "Hello Person, what a nice day"}
  ```

  ```
  iex> partial = "Hello {{ guest.name | capitalize }}"
  ...> MercuryOxide.render("{% include 'greeting' %}, what a nice day", [guest: %{"name" => "person"}], [greeting: partial])
  {:ok, "Hello Person, what a nice day"}
  ```

  """
  alias MercuryOxide.Native

  def render(template, variables), do: render(template, variables, [])

  def render(template, variables, partials) do
    render_needs_convert(
      template,
      variables,
      Keyword.keyword?(variables),
      partials,
      Keyword.keyword?(partials)
    )
  end

  defp render_needs_convert(template, variables, true, partials, true),
    do: Native.render(template, keylist_to_list(variables), keylist_to_list(partials))

  defp render_needs_convert(template, variables, true, [], true),
    do: Native.render(template, keylist_to_list(variables))

  defp render_needs_convert(template, variables, false, [], true),
    do: Native.render(template, variables)

  defp render_needs_convert(template, variables, true, partials, false),
    do: Native.render(template, keylist_to_list(variables), partials)

  defp render_needs_convert(template, variables, false, partials, true),
    do: Native.render(template, variables, keylist_to_list(partials))

  defp render_needs_convert(template, variables, false, partials, false),
    do: Native.render(template, variables, partials)

  defp keylist_to_list(keylist) do
    Enum.map(keylist, fn {k, v} -> {Atom.to_string(k), v} end)
  end
end
