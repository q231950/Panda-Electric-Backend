defmodule HelloPhoenix.Estimate do
  use HelloPhoenix.Web, :model

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {Phoenix.Param, key: :id}

  schema "estimates" do
    field :kind, :string, default: "none"
    field :value, :string, default: "none"
    belongs_to :user, HelloPhoenix.User
    belongs_to :panda_session, HelloPhoenix.PandaSession

    timestamps
  end

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

end
