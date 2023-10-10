defmodule ElixirKafkaChat.ChatMessage do
  use Ecto.Schema
  import Ecto.Changeset
  alias ElixirKafkaChat.ChatMessage

  embedded_schema do 
    field :content, :string
    field :user_name, :string
  end

  @doc false
  def changeset(%ChatMessage{} = chat_message, attrs) do
    chat_message
    |> cast(attrs, [:content, :user_name])
    |> validate_required([:content, :user_name])
  end
end
