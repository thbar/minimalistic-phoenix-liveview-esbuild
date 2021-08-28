import Config

# Configures the endpoint
config :simple, SimpleWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "vuLgz/lXn+03HJIPTHbTMeZGd16UzvFxLgThphnLdafNmlZqCSGEZJe3Hp9cRhVs",
  pubsub_server: Simple.PubSub,
  live_view: [signing_salt: "xF2dLhep"]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.12.18",
  default: [
    args: ~w(js/app.js --bundle --target=es2016 --outdir=../priv/static/assets),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
