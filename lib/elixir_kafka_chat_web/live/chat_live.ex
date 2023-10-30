defmodule ElixirKafkaChatWeb.ChatLive do
  use ElixirKafkaChatWeb, :live_view

  alias ElixirKafkaChat.Chat
  alias Phoenix.PubSub
  alias ElixirKafkaChat.Constants

  on_mount {ElixirKafkaChatWeb.UserAuth, :mount_current_user}

  def mount(_params, _session, socket) do
    if connected?(socket),
      do: PubSub.subscribe(ElixirKafkaChat.PubSub, Constants.pubsub_chat_topic)

    sample_chat = %Chat{
      title: "Sample Title",
      messages: []
    }

    {:ok, stream(socket, :chat_messages, sample_chat.messages)}
  end

  def handle_info({:new_chat_message, message}, socket) do
    message_object =
      Jason.decode!(message, keys: :atoms)
      |> Map.put(:id, Murmur.hash_x86_32(message))

    {:noreply, stream_insert(socket, :chat_messages, message_object)}
  end
end
