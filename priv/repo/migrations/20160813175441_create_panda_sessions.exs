defmodule HelloPhoenix.Repo.Migrations.CreatePandaSessions do
  use Ecto.Migration

  def change do
    create table(:panda_sessions) do
      add :session_id, :string
      add :title, :string

      timestamps
    end

  end
end
