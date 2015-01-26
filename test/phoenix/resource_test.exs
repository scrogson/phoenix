defmodule Phoenix.ResourceTest do
  use ExUnit.Case, async: true

  defmodule User do
    @fallback_to_any true
    defstruct [:id, :name]
  end

  test "name" do
    assert Phoenix.Resource.name(User) == "User"
  end
end
