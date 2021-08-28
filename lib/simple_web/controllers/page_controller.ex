defmodule SimpleWeb.PageController do
  use SimpleWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
