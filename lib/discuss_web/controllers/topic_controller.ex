defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller #Do some fancy setup here
  alias DiscussWeb.Topic
  alias Discuss.Repo

  def index(conn, _params) do
    IO.inspect(conn.assigns)
    topics = Repo.all(Topic) #Get all records of type topic
    render(conn, "index.html", topics: topics)
  end

  @spec new(Plug.Conn.t(), any) :: Plug.Conn.t()
  def new(conn, _params) do
    changeset = Topic.changeset(%Topic{}, %{})

    render(conn, "new.html", changeset: changeset)
  end

  # %{
  #   "_csrf_token" => "KBEWUwMeFAICQSwLfXtiJHwlPxdyGFguySf7HZBHUxFDKB7H2SIXKthE",
  #   "topic" => %{"title" => "Nelson"}
  # } // This is what params looks like, we are pattern matching it away
  def create(conn, %{"topic" => topic}) do
    changeset = Topic.changeset(%Topic{}, topic)

    case Repo.insert(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Created")
        |> redirect(to: Routes.topic_path(conn, :index))
      {:error, changeset} ->
        render conn, "new.html", changeset: changeset
    end
  end

  # Params objecvt should have id in it
  def edit(conn, %{"id" => topic_id}) do
    topic = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(topic)

    render conn, "edit.html", changeset: changeset, topic: topic  # form helpers expects a changeset
  end

  def update(conn, %{"id" => topic_id, "topic" => topic}) do
    old_topic_struct = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(old_topic_struct, topic) #old topic is a struct, new attr from ui is topic

    case Repo.update(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Updated")
        |> redirect(to: Routes.topic_path(conn, :index))
      {:error, changeset} ->
        render conn, "edit.html", changeset: changeset, topic: old_topic_struct
    end
  end

  def delete(conn, %{"id" => topic_id}) do
    retrieved_topic = Repo.get!(Topic, topic_id)

    Repo.delete!(retrieved_topic)
      conn
      |> put_flash(:info, "Topic Deleted")
      |> redirect(to: Routes.topic_path(conn, :index))
  end
end
