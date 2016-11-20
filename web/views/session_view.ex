defmodule HelloPhoenix.SessionView do
  use HelloPhoenix.Web, :view

  def render("index.json", %{sessions: sessions}) do
    IO.puts "[Session View] render session index"
    render_many(sessions, __MODULE__, "session.json")
  end

  def render("session.json", %{session: session}) do
    IO.puts "[Session View] render session"
    %{
      id: session.uuid,
      title: session.title
     }
  end

end
