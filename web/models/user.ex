defmodule HelloPhoenix.User do
  use HelloPhoenix.Web, :model

  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Phoenix.Param, key: :id}

  schema "users" do
    field :name, :string
    has_many :estimates, HelloPhoenix.Estimate
    many_to_many :panda_sessions, HelloPhoenix.PandaSession, join_through: "users_panda_sessions"

    timestamps
  end

  @required_fields ~w(name)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end

defimpl Poison.Encoder, for: HelloPhoenix.User do
  def encode(model, opts) do
    model
      |> Map.take([:name, :id])
      |> Poison.Encoder.encode(opts)
  end
end
