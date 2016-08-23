defmodule HelloPhoenix.Repo.Migrations.CreateUsersPandaSessions do
  use Ecto.Migration

  def change do
    create table(:users_panda_sessions, primary_key: false) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :panda_session_id, references(:panda_sessions, on_delete: :delete_all)
    end
  end
end
