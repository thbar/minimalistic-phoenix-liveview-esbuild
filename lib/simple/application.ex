defmodule Simple.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Phoenix.PubSub, name: Simple.PubSub},
      SimpleWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Simple.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
