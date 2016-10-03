defmodule HelloPhoenix.Repo.Migrations.CreateUsersPandaSessions do
  use Ecto.Migration

  def change do
    create table(:users_panda_sessions) do
      add :user_id, references(:users, on_delete: :delete_all, type: :uuid)
      add :panda_session_id, references(:panda_sessions, on_delete: :delete_all, type: :uuid)
    end
  end
end
