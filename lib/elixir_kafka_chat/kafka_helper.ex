defmodule ElixirKafkaChat.KafkaHelper do
  alias ElixirKafkaChat.Chat
  alias ElixirKafkaChat.Constants

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

  def fetch_latest_messages() do
    latest_offset = get_latest_offset()
    offset_to_start_fetch = if latest_offset >= 10, do: latest_offset - 10, else: 0

    %KafkaEx.Protocol.Fetch.Response{partitions: [%{message_set: message_set}]} =
      KafkaEx.fetch(Constants.kafka_chat_topic(), 0, offset: offset_to_start_fetch)
      |> hd()

    message_set
    |> Enum.map(fn %KafkaEx.Protocol.Fetch.Message{value: message} ->
      decode_message_json(message)
    end)
  end

  def decode_message_json(message) do
    Jason.decode!(message, keys: :atoms)
    |> Map.put(:id, Murmur.hash_x86_32(message))
  end

  defp get_latest_offset() do
    [offset_response] = KafkaEx.latest_offset(Constants.kafka_chat_topic(), 0)

    [%{offset: offset_list}] = offset_response.partition_offsets

    offset_list |> hd()
  end
end
