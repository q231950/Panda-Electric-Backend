defmodule HelloPhoenix.PandaSession do
  use HelloPhoenix.Web, :model

  schema "panda_sessions" do
    field :title, :string
    many_to_many :users, HelloPhoenix.User, join_through: "users_panda_sessions"

    timestamps
  end

  @required_fields ~w(title)
  @optional_fields ~w()

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
