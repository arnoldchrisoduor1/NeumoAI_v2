defmodule NeumoApiWeb.SessionController do
  use NeumoApiWeb, :controller

  alias NeumoApi.Accounts
  alias NeumoApiWeb.ErrorHelpers

  def create(conn, %{"User" => %{"email" => email, "password" => password}}) do
  case Accounts.authenticate_user(email, password) do
    {:ok, user} ->
      conn
      |> put_status(:ok)
      |> json(%{
        message: "Login successful",
        user: %{
          id: user.id,
          email: user.email
        }
      })

    {:error, :unauthorized} ->  # Changed to match Accounts.authenticate_user/2
      conn
      |> put_status(:unauthorized)
      |> json(%{
        error: "Invalid credentials"
      })
  end
end
end
