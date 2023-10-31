defmodule ElixirKafkaChatWeb.ChatLive do
  use ElixirKafkaChatWeb, :live_view

  alias ElixirKafkaChat.Chat
  alias Phoenix.PubSub
  alias ElixirKafkaChat.Constants
  alias ElixirKafkaChat.KafkaHelper

  on_mount {ElixirKafkaChatWeb.UserAuth, :mount_current_user}

  def mount(_params, _session, socket) do
    if connected?(socket),
      do: PubSub.subscribe(ElixirKafkaChat.PubSub, Constants.pubsub_chat_topic())

    socket
    |> assign_message_changeset()
    |> assign_stream_of_messages()
  end

  def handle_info({:new_chat_message, message}, socket) do
    {:noreply, stream_insert(socket, :chat_messages, message |> KafkaHelper.decode_message_json())}
  end

  def handle_event("update_message_content", %{"message" => message}, socket) do
    {:noreply, socket |> assign(:message_changeset, Chat.changeset(%Chat.Message{}, message))}
  end

  def handle_event("send_message", %{"message" => message}, socket) do
    KafkaHelper.send_message(message["user_name"], message["content"])

    message =
      message
      |> Map.update("content", "", fn _ -> "" end)

    {:noreply, assign(socket, :message_changeset, Chat.changeset(%Chat.Message{}, message))}
  end

  defp assign_message_changeset(socket) do
    assign(
      socket,
      :message_changeset,
      Chat.changeset(%Chat.Message{}, %{"user_name" => socket.assigns.current_user.username})
    )
  end

  defp assign_stream_of_messages(socket) do
    sample_chat = %Chat{
      title: "Sample Title",
      messages: KafkaHelper.fetch_latest_messages()
    }

    {:ok, stream(socket, :chat_messages, sample_chat.messages)}
  end
end
