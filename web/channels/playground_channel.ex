defmodule HelloPhoenix.PlaygroundChannel do
  use Phoenix.Channel

  def join("playground:main", message, socket) do
    IO.inspect  message
    {:ok, socket}
  end
  def join("playground:" <> _private_playground_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in("new:msg", %{"body" => body}, socket) do
    broadcast! socket, "new:msg", %{body: body}
    {:noreply, socket}
  end
end
