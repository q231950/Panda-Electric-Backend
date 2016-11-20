defmodule HelloPhoenix.UserAPIController do
  use HelloPhoenix.Web, :controller
  alias HelloPhoenix.Repo
  alias HelloPhoenix.User

  import Ecto.Query

  def index(conn, _params) do
    conn
    |> put_status(403)
    |> json(%{ok: false, message: "Sorry, you can't read the list of users"})
  end

  def create(conn, %{"user" => %{"name" => name} }) do
    user = create_user name
    conn
    |> put_status(200)
    |> render("user.json", user: user)
  end

  defp create_user(name) do
    IO.puts "[User API Controller] create user with name \"#{name}\""
    user = %User{name: name}
    Repo.insert!(user)
  end
end
