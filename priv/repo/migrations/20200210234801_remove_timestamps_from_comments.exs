defmodule Discuss.Repo.Migrations.RemoveTimestampsFromComments do
  use Ecto.Migration

  def change do
    alter table(:comments) do
      remove :inserted_at
      remove :updated_at
    end
  end
end
