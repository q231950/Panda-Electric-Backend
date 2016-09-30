defmodule HelloPhoenix.SessionChannel do
  use Phoenix.Channel

  alias HelloPhoenix.PandaSession

  def join("session:" <> session_id, %{"user" => user}, socket) do
    {:ok, socket}
  end

  def handle_in("new:estimate", %{"fibonacci" => fibonacci}, socket) do
    IO.puts fibonacci
    broadcast! socket, "new:fibonacci_result", %{result: 233}
    {:noreply, socket}
  end
  def handle_in("new:estimate", %{"tshirt" => fibonacci}, socket) do
    IO.puts fibonacci
    broadcast! socket, "new:tshirt_result", %{result: "XL"}
    {:noreply, socket}
  end
end
