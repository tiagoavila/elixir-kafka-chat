defmodule ElixirKafkaChat.Chat do
  use Ecto.Schema
  import Ecto.Changeset
  alias ElixirKafkaChat.Chat

  embedded_schema do
    field :title, :string

    @derive Jason.Encoder
    embeds_many :messages, Message do
      field :content, :string
      field :user_name, :string
      field :sent_datetime, :naive_datetime
    end
  end

  @doc false
  def changeset(%Chat{} = chat, attrs) do
    chat
    |> cast(attrs, [:title, :messages])
    |> validate_required([:title])
  end

  def changeset(%Chat.Message{} = chat_message, attrs) do
    chat_message
    |> cast(attrs, [:content, :user_name])
    |> validate_required([:user_name])
  end

  defimpl Jason.Encoder, for: Chat.Message do
    def encode(value, opts) do
      Jason.Encode.map(
        %{
          content: Map.get(value, :content),
          user_name: Map.get(value, :user_name),
          sent_datetime: Map.get(value, :sent_datetime)
        },
        opts
      )
    end
  end
end
