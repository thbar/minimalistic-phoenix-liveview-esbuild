# Initial skeleton copied from https://gist.github.com/teamon/a964dd80bc5c6802e3a8548efdda9cff
# You can get a quick reloading with `find as_mix_install.exs | entr -cd elixir as_mix_install.exs`
# without having CodeReloader enabled.

Application.put_env(:phoenix, :json_library, Jason)
Application.put_env(:esbuild, :version, "0.12.18")

Mix.install([
  {:phoenix, "~> 1.6.0-rc.0", override: true},
  :jason,
  :plug_cowboy,
  {:phoenix_live_view, "~> 0.16.0"},
  {:esbuild, "~> 0.2"}
])

# NOTE: do not move this before "Mix.install" or the esbuild command will lack
# default parameters, resulting into cryptic error: Invalid transform flag: "--watch"
Application.put_env(:esbuild, :default,
  args: ~w(app.js --bundle --target=es2016 --outdir=priv/static/assets),
  cd: Path.expand("assets", __DIR__),
  env: %{"NODE_PATH" => Path.expand("deps", __DIR__)}
)

Application.put_env(:my_app, MyApp.Endpoint,
  server: true,
  # Binding to loopback ipv4 address prevents access from other machines.
  # Change to `ip: {0, 0, 0, 0}` to allow access from other machines.
  http: [ip: {127, 0, 0, 1}, port: 8081],
  secret_key_base: "vuLgz/lXn+03HJIPTHbTMeZGd16UzvFxLgThphnLdafNmlZqCSGEZJe3Hp9cRhVs",
  live_view: [signing_salt: "xF2dLhep"],
  debug_errors: true,
  watchers: [
    # Start the esbuild watcher by calling Esbuild.install_and_run(:default, args)
    esbuild: {Esbuild, :install_and_run, [:default, ~w(--sourcemap=inline --watch)]}
  ]
)

defmodule SimpleWeb.ClockLive do
  use Phoenix.LiveView
  use Phoenix.HTML
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

defmodule SimpleWeb.LayoutView do
  use Phoenix.View,
    root: "templates",
    namespace: SimpleWeb

  use Phoenix.HTML
  alias MyApp.Router.Helpers, as: Routes
end

defmodule MyApp.Router do
  use Phoenix.Router
  import Phoenix.LiveView.Router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:put_root_layout, {SimpleWeb.LayoutView, :root})
  end

  scope "/" do
    pipe_through([:browser])
    live("/", SimpleWeb.ClockLive)
  end
end

defmodule MyApp.Endpoint do
  use Phoenix.Endpoint, otp_app: :my_app

  @session_options [
    store: :cookie,
    key: "_my_app_key",
    signing_salt: "AD36PbaZ"
  ]

  socket("/live", Phoenix.LiveView.Socket, websocket: [connect_info: [session: @session_options]])

  plug(Plug.Static,
    at: "/",
    from: :simple,
    gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)
  )

  plug(Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()
  )

  plug(Plug.MethodOverride)
  plug(Plug.Head)
  plug(Plug.Session, @session_options)
  plug(MyApp.Router)
end

{:ok, _pid} = MyApp.Endpoint.start_link()

# unless running from IEx, sleep indefinitely so we can serve requests
unless IEx.started?() do
  Process.sleep(:infinity)
end
