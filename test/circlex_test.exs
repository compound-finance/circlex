defmodule CirclexTest do
  use ExUnit.Case
  doctest Circlex

  test "greets the world" do
    assert Circlex.hello() == :world
  end
end
