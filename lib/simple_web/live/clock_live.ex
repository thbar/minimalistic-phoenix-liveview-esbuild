defmodule SimpleWeb.ClockLive do
  use Phoenix.LiveView

  # Use all HTML functionality (forms, tags, etc)
  use Phoenix.HTML

  # Import LiveView and .heex helpers (live_render, live_patch, <.form>, etc)
  import Phoenix.LiveView.Helpers

  def render(assigns) do
    ~H"""
    <div>
      <p>It's <%= @date %></p>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    if connected?(socket), do: :timer.send_interval(1000, self(), :tick)

    {:ok, put_date(socket)}
  end

  def handle_info(:tick, socket) do
    {:noreply, put_date(socket)}
  end

  defp put_date(socket) do
    assign(socket, date: NaiveDateTime.local_now())
  end
end
