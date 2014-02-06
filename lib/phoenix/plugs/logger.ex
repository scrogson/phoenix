defmodule Phoenix.Plugs.Logger do
  use Phoenix.Plug.Middleware

  def before_dispatch(conn) do
    IO.puts "PARAMS: #{inspect conn.params()}"
    {:ok, conn}
  end
end
