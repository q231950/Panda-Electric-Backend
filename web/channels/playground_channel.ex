defmodule HelloPhoenix.PlaygroundChannel do
  use Phoenix.Channel

  def join("playground:main", _message, socket) do
    {:ok, socket}
  end
  def join("playground:" <> _private_playground_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end
end
