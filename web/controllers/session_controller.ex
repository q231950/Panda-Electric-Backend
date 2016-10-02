defmodule HelloPhoenix.SessionController do
  use HelloPhoenix.Web, :controller
  alias HelloPhoenix.Repo
  alias HelloPhoenix.PandaSession
  alias HelloPhoenix.User
  alias HelloPhoenix.PandaSessionUser

  import Ecto.Query

  def index(conn, %{"user" => user}) do
    query = from s in PandaSession, preload: [:users]
    sessions = Repo.all(query)
    render conn, sessions: sessions
  end
  def index(conn, _params) do
    conn
    |> put_status(422)
    |> json(%{ok: false, message: "Missing parameter: user"})
  end

  def create(conn, %{"user" => %{"id" => user_id}, "session" => %{ "title" => title } }) do
    IO.puts "create session #{user_id}, #{title}"

    query = from u in User, where: u.name == ^user_id
    users = Repo.all(query)
    user = List.first(users)

    session = create_session title
    add_user_to_session(session, user)

    # query = from s in PandaSession, preload: [:users]
    # sessions = Repo.all(query)
    conn
    |> put_status(200)
    |> render("session.json", session: session)
  end

  defp create_session(title) do
    IO.puts "[Session] create session #{title}"
    session = %PandaSession{title: title, uuid: UUID.uuid1()}
    session = Repo.insert!(session) |> Repo.preload(:users)
    session
  end

  defp add_user_to_session(session, user) do
    IO.puts "[Session] add user to session: #{ user.name }"
    children_changesets = Enum.map(session.users ++ [user], &Ecto.Changeset.change/1)
    changeset = Ecto.Changeset.put_assoc(Ecto.Changeset.change(session), :users, children_changesets)
    result = Repo.update!(changeset)
    session
  end
end
