defmodule ElixirKafkaChat.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  alias ElixirKafkaChat.KafkaChatConsumer

  @impl true
  def start(_type, _args) do
    consumer_group_opts = [
      # setting for the ConsumerGroup
      heartbeat_interval: 1_000,
      # this setting will be forwarded to the GenConsumer
      commit_interval: 1_000
    ]

    gen_consumer_impl = KafkaChatConsumer
    consumer_group_name = "kafka_ex"
    topic_names = ["chat"]

    children = [
      # Start the Telemetry supervisor
      ElixirKafkaChatWeb.Telemetry,
      # Start the Ecto repository
      ElixirKafkaChat.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: ElixirKafkaChat.PubSub},
      # Start Finch
      {Finch, name: ElixirKafkaChat.Finch},
      # Start the Endpoint (http/https)
      ElixirKafkaChatWeb.Endpoint,
      %{
        id: KafkaEx.ConsumerGroup,
        start: {
          KafkaEx.ConsumerGroup,
          :start_link,
          [gen_consumer_impl, consumer_group_name, topic_names, consumer_group_opts]
        }
      }
      # Start a worker by calling: ElixirKafkaChat.Worker.start_link(arg)
      # {ElixirKafkaChat.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ElixirKafkaChat.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ElixirKafkaChatWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
