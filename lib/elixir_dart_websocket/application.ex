defmodule ElixirDartWebsocket.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ElixirDartWebsocketWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:elixir_dart_websocket, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ElixirDartWebsocket.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: ElixirDartWebsocket.Finch},
      # Start a worker by calling: ElixirDartWebsocket.Worker.start_link(arg)
      # {ElixirDartWebsocket.Worker, arg},
      # Start to serve requests, typically the last entry
      ElixirDartWebsocketWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ElixirDartWebsocket.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ElixirDartWebsocketWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
