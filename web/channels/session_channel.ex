defmodule HelloPhoenix.EstimateChannel do
  use Phoenix.Channel

  alias HelloPhoenix.PandaSession

  def join("session:" <> session_id, %{"user" => user}, socket) do
    {:ok, socket}
  end

  def handle_in("new:estimate", %{"fibonacci" => fibonacci}, socket) do
    IO.puts fibonacci
    broadcast! socket, "new:fibonacci_result", %{fibonacci: 233}
    {:noreply, socket}
  end
  def handle_in("new:estimate", %{"tshirt" => size}, socket) do
    IO.puts size
    broadcast! socket, "new:tshirt_result", %{size: "XL"}
    {:noreply, socket}
  end
end
