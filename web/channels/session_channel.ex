defmodule HelloPhoenix.SessionChannel do
  use Phoenix.Channel

  alias HelloPhoenix.Repo
  alias HelloPhoenix.PandaSession
  alias HelloPhoenix.User
  alias HelloPhoenix.PandaSessionUser

  import Ecto.Query

  def join("sessions:" <> user_id, %{"user" => uuid}, socket) do
    IO.puts "[Session Channel] joining user #{uuid}."
    {:ok, socket}
  end

  def handle_in("read:sessions", %{"user" => uuid}, socket) do
    IO.puts "[Session Channel] request sessions for user #{uuid}."
    query = from s in PandaSession, preload: [:users],
                                    join: user in assoc(s, :users),
                                    where: user.id == ^uuid
    sessions = Repo.all(query)

    Enum.map(sessions, fn(session) ->
      broadcast! socket, "new:session", %{session: %{title: session.title, uuid: session.id}}
    end )
    {:noreply, socket}
  end

  def handle_in("new:session", %{"user" => uuid, "title" => title}, socket) do
    IO.puts "[Session Channel] create new session for user: #{uuid}, #{title}"

    query = from u in User, where: u.id == ^uuid
    users = Repo.all(query)
    user = List.first(users)

    IO.puts "[Session Channel] user name: #{user.name}."

    session = create_session(title)
    add_user_to_session(session, user)

    IO.puts "[Session Channel] broadcast session: #{session.id}."
    broadcast! socket, "new:session", %{session: %{title: session.title, uuid: session.id}}

    {:noreply, socket}
  end

  # def index(conn, %{"user" => user}) do
  #   query = from s in PandaSession, preload: [:users],
  #                                   join: user in assoc(s, :users),
  #                                   where: user.name == ^user
  #   sessions = Repo.all(query)
  #   render conn, sessions: sessions
  # end


  # def create(conn, %{"user" => %{"id" => user_id}, "session" => %{ "title" => title } }) do
  #   IO.puts "create session #{user_id}, #{title}"
  #
  #   query = from u in User, where: u.name == ^user_id
  #   users = Repo.all(query)
  #   user = List.first(users)
  #
  #   session = create_session title
  #   add_user_to_session(session, user)
  #
  #   # query = from s in PandaSession, preload: [:users]
  #   # sessions = Repo.all(query)
  #   conn
  #   |> put_status(200)
  #   |> render("session.json", session: session)
  # end

  defp create_session(title) do
    IO.puts "[Session Channel] create session with title \"#{title}\""
    session = %PandaSession{title: title}
    session = Repo.insert!(session) |> Repo.preload(:users)
    session
  end

  defp add_user_to_session(session, user) do
    IO.puts "[Session Channel] add user: #{ user.id } to session: #{session.id}"
    children_changesets = Enum.map(session.users ++ [user], &Ecto.Changeset.change/1)
    changeset = Ecto.Changeset.put_assoc(Ecto.Changeset.change(session), :users, children_changesets)
    result = Repo.update!(changeset)
    session
  end
end
