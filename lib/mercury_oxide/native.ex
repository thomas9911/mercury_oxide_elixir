defmodule MercuryOxide.Native do
  use Rustler, otp_app: :mercury_oxide, crate: :mercury_oxide

  def render(template, variables) do
    render(template, variables, [])
  end

  def render(_template, _variables, _partials), do: :erlang.nif_error(:nif_not_loaded)
end
