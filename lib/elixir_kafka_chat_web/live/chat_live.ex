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

    message_changeset = %Chat.Message{
      content: "Hello, world!",
      user_name: "Tiago"
    }
    |> Chat.changeset(%{})

    socket = assign(socket, :chat_view_model, %{chat: sample_chat, message: to_form(message_changeset)})
    {:ok, socket}
  end

  def handle_event("send_message", %{"message" => message}, socket) do
    message_json = Jason.encode!(message)

    KafkaEx.produce("chat", 0, message_json)

    sample_chat = %Chat{
      title: "Sample Title",
      messages: [
        %Chat.Message{content: "Hello, world SUBMITTED!", user_name: "User1"},
        %Chat.Message{content: "Hi there SUBMITTED!", user_name: "User2"},
        %Chat.Message{content: "How are you? SUBMITTED", user_name: "User1"}
      ]
    }

    message_changeset = %Chat.Message{
      content: "Lalalalal",
      user_name: "Tiago"
    }
    |> Chat.changeset(%{})

    {:noreply, assign(socket, :chat_view_model, %{chat: sample_chat, message: to_form(message_changeset)})}
  end
end
