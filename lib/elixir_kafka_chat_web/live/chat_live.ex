defmodule ElixirKafkaChatWeb.ChatLive do
  use ElixirKafkaChatWeb, :live_view
  alias ElixirKafkaChat.Chat

  def mount(_params, _session, socket) do
    sample_chat = %Chat{
      title: "Sample Title",
      messages: [
        %Chat.Message{content: "Hello, world!", user_name: "User1"},
        %Chat.Message{content: "Hi there!", user_name: "User2"},
        %Chat.Message{content: "How are you?", user_name: "User1"}
      ]
    }

    socket = assign(socket, :chat, sample_chat)
    {:ok, socket}
  end
end
