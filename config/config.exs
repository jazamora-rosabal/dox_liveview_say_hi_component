# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :say_hi_component, SayHiComponentWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "PG/3xmNXnoUtixQmT7kkXU1YDz6Lt20A3tk2Cg59EFQ926HuS19rr0G6TYeXncAK",
  render_errors: [view: SayHiComponentWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: SayHiComponent.PubSub,
  live_view: [signing_salt: "S2pXgZA3"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
