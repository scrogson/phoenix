defmodule Phoenix.Plug.Middleware do

  defmacro __using__(_options) do
    quote do
      import unquote(__MODULE__)

      defmacro __using__(_options) do
        quote do
          @plugs unquote(__MODULE__)
        end
      end
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      unless  Module.defines? __MODULE__, {:before_dispatch, 0} do
        def before_dispatch(conn), do: conn
      end

      unless  Module.defines? __MODULE__, {:after_dispatch, 0} do
        def after_dispatch(conn), do: conn
      end

      unless  Module.defines? __MODULE__, {:before_action, 0} do
        def before_action(conn), do: conn
      end

      unless  Module.defines? __MODULE__, {:after_action, 0} do
        def after_action(conn), do: conn
      end
    end
  end

  def apply_plugs(plugs, conn) do
    {:ok, conn} = Enum.reduce plugs, {:ok, conn}, fn
      plug, {:ok, current_conn}    -> plug.before_dispatch(current_conn)
      plug, {:halt!, current_conn} -> {:halt!, current_conn}
    end

    conn
  end
end
