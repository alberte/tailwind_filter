defmodule TailwindFilterTest do
  use ExUnit.Case
  doctest TailwindFilter

  test "empty class string stays empty" do
    assert TailwindFilter.filter("") == ""
  end
end
