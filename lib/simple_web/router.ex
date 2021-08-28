defmodule SimpleWeb.Router do
  use SimpleWeb, :router
  import Phoenix.LiveView.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {SimpleWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SimpleWeb do
    pipe_through :browser

    live "/", ClockLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", SimpleWeb do
  #   pipe_through :api
  # end
end
