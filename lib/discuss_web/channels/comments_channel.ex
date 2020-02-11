defmodule DiscussWeb.CommentsChannel do
  alias DiscussWeb.Endpoint, as: Broadcast
  use DiscussWeb, :channel
  alias Discuss.Repo
  alias DiscussWeb.Topic
  alias DiscussWeb.Comment

  # Called for first time communication
  def join("comments:" <> topic_id, _params, socket) do
    topic_id = String.to_integer(topic_id)
    topic = Topic
      |> Repo.get(topic_id)
      |> Repo.preload(:comments)

    {:ok, %{comments: topic.comments}, assign(socket, :topic, topic)}
  end

  # Called whenever a user broadcasts an event from the javascript side of the application
  def handle_in(_name, %{"content" => content}, socket) do
    topic = socket.assigns.topic
    # user_id = socket.assigns.user_id

    changeset = topic
      |> build_assoc(:comments)
      |> Comment.changeset(%{content: content})

    case Repo.insert(changeset) do
      {:ok, comment} ->
        Broadcast.broadcast!(socket, "comments:#{socket.assigns.topic.id}:new", %{comment: comment})
        {:reply, :ok, socket}
      {:error, _reason} ->
        {:reply, {:error, %{errors: changeset}},socket}
    end
  end
end
