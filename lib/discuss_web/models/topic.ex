defmodule DiscussWeb.Topic do
  use DiscussWeb, :model

  # Implement a model schema for our database table topics
  schema "topics" do
    field :title, :string
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title])
    |> validate_required([:title])
  end
end
