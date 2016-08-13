defmodule HelloPhoenix.PandaSession do
  use HelloPhoenix.Web, :model

  schema "panda_sessions" do
    field :session_id, :string

    timestamps
  end

  @required_fields ~w(session_id)
  @optional_fields ~w(title)

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
