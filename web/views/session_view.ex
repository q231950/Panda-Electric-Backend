defmodule HelloPhoenix.SessionView do
  use HelloPhoenix.Web, :view

  def render("index.json", %{sessions: sessions}) do
    render_many(sessions, __MODULE__, "session.json")
  end

  def render("session.json", %{session: session}) do
    %{
      uuid: session.uuid,
      title: session.title
     }
  end

end
