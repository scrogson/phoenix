defmodule Phoenix.Router.Adapters.Cowboy do

  @defaults [
    static: [mount: "/assets", priv_dir: "assets"]
  ]

  def normalize_options(options, module) do
    dispatch    = options[:dispatch] || []
    static_opts = static_options(options[:static] || @defaults[:static], module)

    Dict.merge options, [
      dispatch: [static_opts | dispatch]
    ]
  end

  defp static_options(options, module ) do
    path = Keyword.fetch!(options, :mount)
    dir  = Keyword.fetch!(options, :priv_dir)

    {:_, [
      {Path.join(path,"[...]"), :cowboy_static, {:dir, Path.join("priv", dir)}},
      {:_, Plug.Adapters.Cowboy.Handler, { module, [] }}
    ]}
  end
end

