defmodule Phoenix.Router do
  use GenServer.Behaviour
  alias Phoenix.Dispatcher
  alias Phoenix.Controller
  alias Phoenix.Router.Path
  alias Phoenix.Plug.Middleware

  defmacro __using__(plug_adapter_options // []) do
    quote do
      use Phoenix.Router.Mapper
      use Phoenix.Plug.Pluggable
      import unquote(__MODULE__)

      @options unquote(plug_adapter_options)

      def start do
        IO.puts "Running #{__MODULE__} with Cowboy with #{inspect @options}"
        Plug.Adapters.Cowboy.http __MODULE__, [], @options
      end

      def call(conn, []) do
        Phoenix.Router.dispatch(conn, __MODULE__)
      end
    end
  end

  def dispatch(conn, router) do
    conn        = Plug.Connection.fetch_params(conn)
    http_method = conn.method |> String.downcase |> binary_to_atom
    split_path  = Path.split_from_conn(conn)
    params      = conn.params
    conn        = Middleware.apply_plugs(router.plugs, conn)

    request = Dispatcher.Request.new(conn: conn,
                                     router: router,
                                     http_method: http_method,
                                     path: split_path)

    {:ok, pid} = Dispatcher.Client.start(request)
    case Dispatcher.Client.dispatch(pid) do
      {:ok, conn}      -> {:ok, conn}
      {:error, reason} -> Controller.error(conn, reason)
    end
  end
end

