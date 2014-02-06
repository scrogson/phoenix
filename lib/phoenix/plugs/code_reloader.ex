defmodule Phoenix.Plugs.CodeReloader do
  use Phoenix.Plug.Middleware

  def before_dispatch(conn) do
    if Mix.env == :dev, do: reload_all_code

    {:ok, conn}
  end

  defp reload_all_code do
    IO.puts ">> Reloading code"
    Mix.Tasks.Compile.Elixir.run([])
  end
end
