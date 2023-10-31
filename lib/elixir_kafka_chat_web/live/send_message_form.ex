defmodule ElixirKafkaChatWeb.SendMessageForm do
  @moduledoc false

  use ElixirKafkaChatWeb, :live_component
  import ElixirKafkaChatWeb.CoreComponents
  alias ElixirKafkaChat.Chat
  alias ElixirKafkaChat.Constants

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_changeset}
  end

  def assign_changeset(socket) do
    assign(socket, :changeset, Chat.changeset(%Chat.Message{}, %{"user_name" => socket.assigns.current_user.username}))
  end

  def render(assigns) do
    ~H"""
    <div class="bt mt-10">
      <.form
        :let={f}
        for={@changeset}
        phx-submit="send_message"
        phx-change="update"
        phx-target={@myself}
      >
        <.input field={f[:user_name]} type="hidden" />
        <.input field={f[:content]} type="textarea" />
        <.button class="fr mt-2">Send!</.button>
      </.form>
    </div>
    """
  end

  def handle_event("update", %{"message" => message}, socket) do
    {:noreply, socket |> assign(:changeset, Chat.changeset(%Chat.Message{}, message))}
  end

  def handle_event("send_message", %{"message" => message}, socket) do
    send_message(message["user_name"], message["content"])

    message = message
    |> Map.update("content", "", fn _ -> "" end)

    {:noreply, assign(socket, :changeset, Chat.changeset(%Chat.Message{}, message))}
  end

  def send_message(user_name, content) do
    new_message =
      %Chat.Message{
        content: content,
        user_name: user_name,
        sent_datetime: NaiveDateTime.utc_now()
      }
      |> Jason.encode!()

    KafkaEx.produce(Constants.kafka_chat_topic(), 0, new_message)
  end
end
