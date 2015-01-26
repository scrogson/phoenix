defprotocol Phoenix.Resource do
  @moduledoc """
  Provides a protocol for Models to implement for common resource behaviour.
  """

  @type resource :: map | module

  @doc """
  Resource name introspection.
  """
  @spec name(resource) :: String.t
  def name(resource)

  @doc """
  """
  @spec param_key(resource) :: String.t
  def param_key(resource)

  @doc """
  """
  @spec to_param(resource) :: any
  def to_param(resource)

end

defimpl Phoenix.Resource, for: Any do
  def name(resource) do
    resource |> to_string
  end

  def param_key(%{__struct__: mod}), do: param_key(mod)
  def param_key(resource) when is_atom(resource) do
    resource
    |> Module.split
    |> List.last
    |> String.downcase
  end

  def to_param(%{"id" => id}), do: id
end
