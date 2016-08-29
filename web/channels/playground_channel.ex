defmodule HelloPhoenix.PlaygroundChannel do
  use Phoenix.Channel
  alias HelloPhoenix.Repo
  alias HelloPhoenix.User
  alias HelloPhoenix.PandaSessionUser
  alias HelloPhoenix.PandaSession
  import Ecto.Query

  def join("playground:main", %{"user" => user}, socket) do
    IO.puts "[Join] name: \"#{user}\""
    user_exists(user)
    |> panda_session_for_user

    {:ok, socket}
  end
  def join("playground:" <> _private_playground_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in("new:msg", %{"body" => body}, socket) do
    IO.puts body
    broadcast! socket, "new:msg", %{body: body, position: 3}
    {:noreply, socket}
  end

  defp user_exists(user_name) do
    query = from u in User, where: u.name == ^user_name
    users = Repo.all(query)
    user = List.first(users)
    case user do
      nil -> IO.puts "[User] no record found for: \"#{user_name}\""
      u -> IO.inspect(user)
    end
    user
  end

  defp panda_session_for_user(user) do
    query = from s in PandaSession, join: user in assoc(s, :users),
                                    where: user.id == ^user.id
    panda_session = Repo.all(query)
    case panda_session do
      [] -> create_or_join_session(user)
      [s] ->
        IO.puts "[Session] existing session found for #{ user.name }: #{s.title}."
        panda_session
    end
  end

  defp create_or_join_session(user) do
    case joinable_sessions(user) do
      nil ->
        IO.puts "[Session] none available"
        create_session |> add_user_to_session(user)
      x ->
        IO.puts "[Session] found"
        add_user_to_session(x, user)
    end
  end

  defp create_session do
    IO.puts "[Session] create session"
    session = %PandaSession{title: "a panda session"}
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

  defp joinable_sessions(user) do
    query = from s in PandaSession, preload: [:users]
    panda_sessions = Repo.all(query)
    IO.puts "[Session] joinable sessions: #{ Enum.count(panda_sessions) }"
    # find a session with only one user
    panda_session = Enum.find( panda_sessions, fn(s) -> Enum.count(s.users) == 1 end )
    IO.inspect panda_session
    panda_session
  end
end
