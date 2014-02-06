defmodule Phoenix.Plug.Pluggable do

  defmacro __using__(_options) do
    quote do
      Module.register_attribute __MODULE__, :plugs, accumulate: true,
                                                    persist: false
      @before_compile unquote(__MODULE__)
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def plugs, do: @plugs
    end
  end
end
