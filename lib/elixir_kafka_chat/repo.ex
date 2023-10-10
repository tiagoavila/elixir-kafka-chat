defmodule ElixirKafkaChat.Repo do
  use Ecto.Repo,
    otp_app: :elixir_kafka_chat,
    adapter: Ecto.Adapters.Postgres
end
