defmodule HelloPhoenix.PandaSession do
  use HelloPhoenix.Web, :model

  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Phoenix.Param, key: :id}

  schema "panda_sessions" do
    field :title, :string
    many_to_many :users, HelloPhoenix.User, join_through: "users_panda_sessions"
    has_many :estimates, HelloPhoenix.Estimate

    timestamps
  end

  @required_fields ~w(title)
  @optional_fields ~w()

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
