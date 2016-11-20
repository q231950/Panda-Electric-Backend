defmodule HelloPhoenix.UserAPIView do
  use HelloPhoenix.Web, :view

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      name: user.name
     }
  end

end
