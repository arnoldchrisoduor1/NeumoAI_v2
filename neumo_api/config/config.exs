# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :neumo_api, NeumoApi.Guardian,
  issuer: "NeumoApi",
  secret_key: System.get_env("GUARDIAN_SECRET_KEY") || "will_change_this_secret_key_in_production",
  ttl: {3, :days},
  token_headers: [{"typ", "JWT"}, {"alg", "HS512"}],
  serializer: NeumoApi.Guardian.Serializer

config :neumo_api,
  ecto_repos: [NeumoApi.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :neumo_api, NeumoApiWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [json: NeumoApiWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: NeumoApi.PubSub,
  live_view: [signing_salt: "wi3gqmEI"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :neumo_api, NeumoApi.Mailer, adapter: Swoosh.Adapters.Local

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
