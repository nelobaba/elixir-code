defmodule DiscussWeb.User do
  use DiscussWeb, :model

  # Implement a model schema for our database table topics
  schema "users" do
    field :email, :string
    field :provider, :string
    field :token, :string
    has_many(:topics, DiscussWeb.Topic) #Each user has many topics and each topic should be an instance of DiscussWeb.Topic
    has_many(:comments, DiscussWeb.Comment)

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :provider, :token])
    |> validate_required([:email, :provider, :token])
  end
end
