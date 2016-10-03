defmodule HelloPhoenix.Repo.Migrations.CreatePandaSessions do
  use Ecto.Migration

  def change do
    create table(:panda_sessions, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :title, :string

      timestamps
    end

  end
end
