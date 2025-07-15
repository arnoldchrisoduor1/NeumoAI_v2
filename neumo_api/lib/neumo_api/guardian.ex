defmodule NeumoApi.Guardian do
  use Guardian, otp_app: neumo_api

  # creating the resource guardian will use to identify the user.
  def subject_for_token(%{id: id}, _claims) do
    {:ok, to_string(id)}
  end

  def subject_for_token(_, _) do
    {:error, "unknown resource"}
  end

  # How guardian will retrieve the user based on the id(subject).
  def resource_from_claims(%{"sub" => id}) do
    case NeumoApi.Accounts.get_user(id) do
      nil -> {:error, "User not found"}
      user -> {:ok, user}
    end
  end

  def reource_from_claims(_claims) do
    {:error, "No subject in claims"}
  end

  # i will use the :api as the default token strategy.
  defp token_strategy do
    :api
  end

  # defining specifi claims for different token types if needed.
  def claims_for_token(resource, _claims) do
    # Adding custom claims into the JWT payload.
    {:ok, %{"user_id" => resource.id}}
  end
end
