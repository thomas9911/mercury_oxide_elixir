defmodule MercuryOxideTest do
  use ExUnit.Case
  doctest MercuryOxide

  test "render correctly" do
    assert {:ok, "Liquid! 13"} ==
             MercuryOxide.render("Liquid! {{num | minus: 2}}", [{"num", "15"}])
  end

  test "render correctly keyword" do
    assert {:ok, "Liquid! 13"} ==
             MercuryOxide.render("Liquid! {{num | minus: 2}}", num: "15")
  end

  test "render invalid globals" do
    assert :render_error == MercuryOxide.render("Liquid! {{num | minus: 2}}", [{"test", "15"}])
  end

  test "render invalid template" do
    assert :invalid_template ==
             MercuryOxide.render("Liquid! {{{num | minus: 2}}", [{"test", "15"}])
  end

  test "render with partials" do
    partial = "Hey from partial"

    assert {:ok, "Hey from partial Testing 13"} ==
             MercuryOxide.render(
               "{% include 'partial' %} Testing {{num | minus: 2}}",
               [num: "15"],
               [{"partial", partial}]
             )
  end

  test "render with partials keyword" do
    partial = "Hey from partial"

    assert {:ok, "Hey from partial Testing 13"} ==
             MercuryOxide.render(
               "{% include 'partial' %} Testing {{num | minus: 2}}",
               [num: "15"],
               partial: partial
             )
  end
end
