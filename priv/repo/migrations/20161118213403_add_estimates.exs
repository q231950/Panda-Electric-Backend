defmodule HelloPhoenix.Repo.Migrations.AddEstimates do
  use Ecto.Migration

  def change do
    create table(:estimates, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :kind, :string
      add :value, :string
      add :user_id, references(:users, on_delete: :nothing, type: :uuid)
      add :panda_session_id, references(:panda_sessions, on_delete: :nothing, type: :uuid)

      timestamps
    end

    # create table(:estimates_panda_sessions) do
    #   add :estimate_id, references(:estimates, on_delete: :delete_all, type: :uuid)
    #   add :panda_session_id, references(:panda_sessions, on_delete: :delete_all, type: :uuid)
    # end
  end
end
