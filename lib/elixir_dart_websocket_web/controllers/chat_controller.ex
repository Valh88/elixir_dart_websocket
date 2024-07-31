defmodule ElixirDartWebsocketWeb.ChatController do
  use ElixirDartWebsocketWeb, :controller

  def chat(conn, _params) do
    render(conn, :chat)
  end
end
