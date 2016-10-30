defmodule HelloPhoenix.EstimationChannel do
  use Phoenix.Channel

  alias HelloPhoenix.PandaSession

  def join("estimation:" <> session_id, %{"user" => user}, socket) do
    IO.puts "[Estimation Channel] User joins: #{user}"
    socket = assign(socket, :session_uuid, session_id)

    IO.inspect socket.assigns
    users = usersArray(socket.assigns[:users], [%{ user => "" }])

    socket = assign(socket, :users, users)
    IO.inspect socket.assigns[:users]
    {:ok, socket}
  end

  defp usersArray(currentUsers, newUsers) do
    if is_nil(currentUsers) do
      IO.puts "Users is nil, need to return new users"
      newUsers
    else
      IO.puts "Users is available"
      IO.inspect(currentUsers ++ newUsers)
      currentUsers ++ newUsers
    end
  end

  def handle_in("new:estimate", %{"fibonacci" => fibonacci, "user" => user_id}, socket) do
    IO.puts "[Estimation Channel] New estimation(fibonacci) #{fibonacci} from user #{user_id} in session #{socket.assigns[:session_uuid]}"
    IO.inspect socket.assigns

    broadcast! socket, "new:fibonacci_result", %{fibonacci: fibonacci}

    {:noreply, socket}
  end
  def handle_in("new:estimate", %{"tshirt" => size}, socket) do
    IO.puts size
    broadcast! socket, "new:tshirt_result", %{size: size}
    {:noreply, socket}
  end
end
