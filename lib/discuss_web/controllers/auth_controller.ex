defmodule DiscussWeb.AuthController do
  use DiscussWeb, :controller
  plug Ueberauth #tightly couple this controller to Ueberauth
  alias DiscussWeb.User
  alias Discuss.Repo

  # This function will be called when github redirects back to
  # our application with user details, Ueberauth expects us to define this function
  # When a user is logged_in, we add the user id to the cookies and subsequent requests
  # are made with the user id in the cookie... when the user tries to login again
  # the id is gotten from the cookie----> we use that as a session with user id
  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, params) do
    user_params = %{token: auth.credentials.token, email: auth.info.email, provider: "github"}
    changeset = User.changeset(%User{}, user_params)

    signin(conn, changeset)
  end

  def signout(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: Routes.topic_path(conn, :index))
  end

  defp signin(conn, changeset) do
    case isert_or_update_user(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> put_session(:user_id, user.id) #puts id in user's cookie
        |> redirect(to: Routes.topic_path(conn, :index))
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Error Signing in")
        |> redirect(to: Routes.topic_path(conn, :index))
    end
  end

  defp isert_or_update_user(changeset) do
    case Repo.get_by(User, email: changeset.changes.email) do
      nil ->
        Repo.insert(changeset)
      user ->
        {:ok, user}
    end
  end
end
