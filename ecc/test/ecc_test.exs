defmodule EccTest do
  use ExUnit.Case
  doctest Ecc

  test "greets the world" do
    assert Ecc.hello() == :world
  end
end
