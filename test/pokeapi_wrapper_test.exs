defmodule PokeapiWrapperTest do
  use ExUnit.Case
  doctest PokeapiWrapper

  test "greets the world" do
    assert PokeapiWrapper.hello() == :world
  end
end
