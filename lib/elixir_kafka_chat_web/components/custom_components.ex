defmodule ElixirKafkaChatWeb.CustomComponents do
  def set_user_message_class(user1, user1), do: "message sender"
  def set_user_message_class(_, _), do: "message receiver"
end
