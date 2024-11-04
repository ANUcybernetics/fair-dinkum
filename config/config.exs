# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :ash, :default_belongs_to_type, :integer

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  fair_dinkum: [
    args: ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :fair_dinkum, FairDinkum.Mailer, adapter: Swoosh.Adapters.Local

# Configures the endpoint
config :fair_dinkum, FairDinkumWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: FairDinkumWeb.ErrorHTML, json: FairDinkumWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: FairDinkum.PubSub,
  live_view: [signing_salt: "0QEzbdMk"]

config :fair_dinkum,
  ash_domains: [FairDinkum.Players, FairDinkum.Game]

config :fair_dinkum,
  ecto_repos: [FairDinkum.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.3",
  fair_dinkum: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    # Import environment specific config. This must remain at the bottom
    # of this file so it overrides the configuration defined above.
    cd: Path.expand("../assets", __DIR__)
  ]

import_config "#{config_env()}.exs"
