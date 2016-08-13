defmodule HelloPhoenix.PlaygroundChannel do
  use Phoenix.Channel
  alias HelloPhoenix.Repo
  alias HelloPhoenix.User
  import Ecto.Query

  def join("playground:main", %{"user" => user}, socket) do
    IO.puts user
    user_exists(user)
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
    List.first(users)
  end
end
