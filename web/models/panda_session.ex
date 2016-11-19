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

  def with_estimates_and_users(query) do
    from q in query, preload: [:users, estimates: [:user]]
  end
end

defimpl Poison.Encoder, for: HelloPhoenix.PandaSession do
  def encode(model, opts) do
    model
      |> Map.take([:title, :estimates, :id, :users])
      |> Poison.Encoder.encode(opts)
  end
end
