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
end
