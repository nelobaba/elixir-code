defmodule DiscussWeb.Plugs.SetUser do
  import Plug.Conn
  import Phoenix.Controller

  alias DiscussWeb.User
  alias Discuss.Repo

  # A module Plug must have init and call, init is called once, and call
  # is call whenever the plug executes, init runs once and the returned
  # data is injected subsequently as a second argument to the call function as params

  def init(_params) do
  end

  def call(conn, _params) do
    user_id = get_session(conn, :user_id)  #this is the opposite of put_session

    cond do
      user = user_id && Repo.get(User, user_id) ->
        assign(conn, :user, user)
      true ->
        assign(conn, :user, nil)
    end
  end
end
