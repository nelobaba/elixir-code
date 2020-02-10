defmodule DiscussWeb.Plugs.RequireAuth do
  import Plug.Conn
  import Phoenix.Controller
  alias DiscussWeb.Router.Helpers, as: Routes

  def init(_params) do
  end

  @spec call(atom | %{assigns: nil | keyword | map}, any) :: nil
  def call(conn, _params) do
    if conn.assigns[:user] do
      conn #return conn to make the request continue
    else
      conn
      |> put_flash(:error, "You must be logged in.")
      |> redirect(to: Routes.topic_path(conn, :index))
      |> halt()
    end
  end
end
