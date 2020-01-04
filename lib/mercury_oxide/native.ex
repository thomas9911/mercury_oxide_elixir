defmodule MercuryOxide.Native do
  use Rustler, otp_app: :mercury_oxide, crate: :mercury_oxide

  def render(_arg1, _arg2), do: :erlang.nif_error(:nif_not_loaded)
  def render(_arg1, _arg2, _arg3), do: :erlang.nif_error(:nif_not_loaded)
end
