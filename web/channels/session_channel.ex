defmodule HelloPhoenix.SessionChannel do
  use Phoenix.Channel

  alias HelloPhoenix.Repo
  alias HelloPhoenix.PandaSession
  alias HelloPhoenix.User
  alias HelloPhoenix.PandaSessionUser
  alias HelloPhoenix.Estimate

  import Ecto.Query

  def join("sessions:" <> user_id, %{"user" => uuid}, socket) do
    IO.puts "[Session Channel] joining user #{uuid}."
    {:ok, socket}
  end

  def handle_in("read:sessions", %{"user" => uuid}, socket) do
    IO.puts "[Session Channel] request sessions for user #{uuid}."

    query = from s in PandaSession, preload: [:users, estimates: [:user]],
                                    join: user in assoc(s, :users),
                                    where: user.id == ^uuid

    sessions = Repo.all(query)

     {:reply, {:ok, %{ :sessions => sessions }}, socket}
  end

  def handle_in("new:session", %{"user" => uuid, "title" => title}, socket) do
    IO.puts "[Session Channel] create new session for user: #{uuid}, #{title}"

    query = from u in User, where: u.id == ^uuid
    users = Repo.all(query)
    user = List.first(users)

    create_session(title)
    |> add_user_to_session(user)
    |> socket_session_reply(socket)
  end

  defp socket_session_reply(session, socket) do
    {:reply, {:ok, %{ :session => session }}, socket}
  end

  def handle_in("join:session", %{"user" => user_id, "uuid" => uuid}, socket) do
    session_query = from s in PandaSession, where: s.id == ^uuid
    sessions = Repo.all(session_query) |> Repo.preload([:users, estimates: [:user]])
    session = List.first(sessions)

    query = from u in User, where: u.id == ^user_id
    users = Repo.all(query)
    user = List.first(users)

    IO.puts "[Session Channel] #{ user.name } (#{ user_id }) joins session #{ session.title }."

    add_user_to_session(session, user)
    |> socket_session_reply(socket)
  end

  def handle_in("delete:session", %{"user" => user_id, "uuid" => uuid}, socket) do
    IO.puts "delete session #{user_id}, #{uuid}"
    {:reply, {:error, %{"reason"=> "not implemented"}}, socket}
  end

  def handle_in(_anyTopic, _anyPayload, socket) do
    {:reply, {:error, %{"reason"=> "unmached"}}, socket}
  end

  defp create_session(title) do
    IO.puts "[Session Channel] create session with title \"#{title}\""
    session = %PandaSession{title: title}
    session = Repo.insert!(session) |> Repo.preload([:users, estimates: [:user]])
    session
  end

  defp add_user_to_session(session, user) do
    IO.puts "[Session Channel] add user: #{ user.id } to session: #{session.id}"
    users_changes = Enum.map(session.users ++ [user], &Ecto.Changeset.change/1)
    users_changeset = Ecto.Changeset.put_assoc(Ecto.Changeset.change(session), :users, users_changes)
    Repo.update!(users_changeset)

    session
    |> add_estimate_to_user_session(user)
  end

  defp add_estimate_to_user_session(session, user) do
    estimate = %Estimate{user: user, panda_session: session}
    Repo.insert!(estimate) |> Repo.preload(:user)
    session
  end
end
