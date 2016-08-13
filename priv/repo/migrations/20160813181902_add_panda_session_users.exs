defmodule HelloPhoenix.Repo.Migrations.AddPandaSessionUsers do
  use Ecto.Migration

  def change do
    create table(:panda_session_users) do
      add :session_id, :integer
      add :user_id, :integer

      timestamps
    end

  end
end
