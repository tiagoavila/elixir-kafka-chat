defmodule ElixirKafkaChat.Chat do
  use Ecto.Schema
  import Ecto.Changeset
  alias ElixirKafkaChat.Chat

  embedded_schema do
    field :title, :string

    embeds_many :messages, Message do
      field :content,   :string
      field :user_name, :string
    end
  end

  @doc false
  def changeset(%Chat{} = chat, attrs) do
    chat
    |> cast(attrs, [:title, :messages])
    |> validate_required([:title])
  end
end
