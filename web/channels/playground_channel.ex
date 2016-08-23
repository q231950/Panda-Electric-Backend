defmodule HelloPhoenix.PlaygroundChannel do
  use Phoenix.Channel
  alias HelloPhoenix.Repo
  alias HelloPhoenix.User
  alias HelloPhoenix.PandaSessionUser
  alias HelloPhoenix.PandaSession
  import Ecto.Query

  def join("playground:main", %{"user" => user}, socket) do
    IO.puts "[Join] #{user}"
    user_exists(user)
    |> panda_session_for_user
    |> IO.inspect

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
      nil -> IO.puts "User with name: \"#{user_name}\" does not exist yet."
      u -> IO.inspect(user)
    end
    user
  end

  defp panda_session_for_user(user) do
    query = from s in PandaSession, join: user in assoc(s, :users),
                                    where: user.id == ^user.id
    panda_session = Repo.all(query)
    case panda_session do
      [] -> create_session |> add_user_to_session(user)
      [s] ->
      IO.puts "Session for #{user.name}: #{s.title}."
      panda_session
    end
  end

  defp create_session do
    IO.puts "Create session..."
    session = %PandaSession{title: "a panda session"}
    session = Repo.insert!(session) |> Repo.preload(:users)
    IO.inspect session
    session
  end

  defp add_user_to_session(session, user) do
    changeset = Ecto.Changeset.change(session) |> Ecto.Changeset.put_assoc(:users, [user])
    result = Repo.update!(changeset)
    IO.inspect result
    session
  end
end
