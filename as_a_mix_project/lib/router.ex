defmodule SimpleWeb.Router do
  use Phoenix.Router

  import Plug.Conn
  import Phoenix.LiveView.Router

  pipeline :browser do
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {SimpleWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", SimpleWeb do
    pipe_through :browser

    live "/", ClockLive
  end
end
