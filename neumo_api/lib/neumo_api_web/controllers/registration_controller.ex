defmodule NeumoApiWeb.RegistrationController do
  use NeumoApiWeb, :controller

  alias NeumoApi.Accounts
  alias NeumoApiWeb.ErrorHelpers

  def create(conn, %{"User" => user_params}) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> json(%{
          message: "User created successfully",
          user: %{
            id: user.id,
            email: user.email
          }
        })

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{
          error: "Registration failed",
          details: ErrorHelpers.translate_errors(changeset)
        })
    end
  end
end
