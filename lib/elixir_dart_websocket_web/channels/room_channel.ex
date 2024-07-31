defmodule ElixirDartWebsocketWeb.RoomChannel do
  use ElixirDartWebsocketWeb, :channel

  @impl true
  def join("room:*", payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def join("room:" <> _name, payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end
  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("message", %{"message" => _message, "from" => _id} = data, socket) do
    broadcast(socket, "message", data)
    {:reply, {:ok, data}, socket}
  end

  def handle_in("user", %{"from" => _user_id} = user, socket) do
    IO.inspect(user)
    broadcast(socket, "from", user)
    {:reply, {:ok, user}, socket}
  end
  # Add authorization logic here as required.
  defp authorized?(payload) do
    IO.inspect(payload)
    true
  end
end
