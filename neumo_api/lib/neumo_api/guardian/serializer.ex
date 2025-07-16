defmodule NeumoApi.Guardian.Serializer do
  @behaviour Guardian.Serializer

  alias NeumoApi.Accounts
  alias NeumoApi.Accounts.User

  def for_token(%User{} = user) do
    {:ok, "User:#{user.id}"}
  end

  def for_token("User:" <> id) do
    case Accounts.get_user(id) do
      nil -> {:error, "User not found"}
      user -> {:ok, user}
    end
  end

  def from_token(_), do: {"error", "Unknown resource format"}
end
