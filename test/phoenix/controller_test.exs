defmodule Phoenix.Router.ControllerTest do
  use ExUnit.Case
  use PlugHelper

  defmodule RedirController do
    use Phoenix.Controller
    def redir_301(conn) do
      redirect conn, 301, "/users"
    end
    def redir_302(conn) do
      redirect conn, "/users"
    end
  end

  defmodule AtomStatusController do
    use Phoenix.Controller

    def atom(conn) do
      status_atom = String.to_atom(conn.params["status"])
      text conn, status_atom
    end
  end

  defmodule Router do
    use Phoenix.Router
    get "/users/not_found_301", RedirController, :redir_301
    get "/users/not_found_302", RedirController, :redir_302
    get "/atom/:status", AtomStatusController, :atom
  end

  test "redirect without status performs 302 redirect do url" do
    conn = simulate_request(Router, :get, "users/not_found_302")
    assert conn.status == 302
  end

  test "redirect without status performs 301 redirect do url" do
    conn = simulate_request(Router, :get, "users/not_found_301")
    assert conn.status == 301
  end

  test "accepts atoms as http statuses" do
    conn = simulate_request(Router, :get, "atom/ok")
    assert conn.status == 200

    conn = simulate_request(Router, :get, "atom/not_found")
    assert conn.status == 404
  end
end
