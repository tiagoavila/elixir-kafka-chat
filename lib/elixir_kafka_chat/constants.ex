defmodule ElixirKafkaChat.Constants do
  @pubsub_chat_topic "chat"
  @kafka_chat_topic "chat"

  def pubsub_chat_topic, do: @pubsub_chat_topic

  def kafka_chat_topic, do: @kafka_chat_topic
end
