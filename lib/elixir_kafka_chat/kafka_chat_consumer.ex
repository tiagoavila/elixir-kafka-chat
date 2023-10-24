defmodule ElixirKafkaChat.KafkaChatConsumer do
  use KafkaEx.GenConsumer

  alias KafkaEx.Protocol.Fetch.Message
  alias Phoenix.PubSub
  alias ElixirKafkaChat.Constants

  require Logger

  # note - messages are delivered in batches
  def handle_message_set(message_set, state) do
    for %Message{value: message} <- message_set do
      Logger.debug(fn -> "message received from KAFKA: " <> inspect(message) end)
      PubSub.broadcast(ElixirKafkaChat.PubSub, Constants.pubsub_chat_topic, {:new_chat_message, message})
    end

    {:async_commit, state}
  end
end
