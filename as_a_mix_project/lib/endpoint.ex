defmodule SimpleWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :simple

  @session_options [
    store: :cookie,
    key: "_simple_key",
    signing_salt: "1ZGApOpa"
  ]

  socket "/live", Phoenix.LiveView.Socket, websocket: [connect_info: [session: @session_options]]

  plug Plug.Static,
    at: "/",
    from: :simple,
    gzip: false,
    only: ~w(assets)

  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.Session, @session_options
  plug SimpleWeb.Router
end
