defmodule DiscussWeb.UserSocket do
  use Phoenix.Socket

  ## Channels
  # channel "room:*", DiscussWeb.RoomChannel, first arg is the channel the client wanna join and the second arg is the module responsible for the channel
  #  The module should implement join and handle_in function

  channel "comments:*", DiscussWeb.CommentsChannel

  def connect(%{"token" => token}, socket, _connect_info) do #socket is like conn obj in the phoenix controller
    case Phoenix.Token.verify(socket, "key", token) do
      {:ok, user_id} ->
        {:ok, assign(socket, :user_id, user_id)}
      {:error, _error} ->
        :error
    end
    {:ok, socket}
  end

  # Returning `nil` makes this socket anonymous.
  def id(_socket), do: nil
end
