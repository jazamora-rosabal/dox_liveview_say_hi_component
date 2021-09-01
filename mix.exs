defmodule SayHiComponent.MixProject do
  use Mix.Project

  def project do
    [
      app: :say_hi_component,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix_live_view, "~> 0.11.0 or ~> 0.12.0 or ~> 0.13.0 or ~> 0.14.0 or ~> 0.15.0"},
      {:phoenix_html, "~> 2.11"},
      {:timex, "~> 3.6.3"}
    ]
  end

end
