defmodule NeumoApiWeb.SessionController do
  use NeumoApiWeb, :controller

  alias NeumoApiWeb.Accounts
  alias NeumoApiWeb.Guardian

  action_fallback NeumoApiWeb.FallbackController

  @doc """
  Handles user login.
  Expects: %{"email" => "...", "password" => "..."}
  Returns:  JWT token on success.
  """
  def create(conn, %{"email" => email, "password" => password}) do
    with {:ok, user} <- Accounts.authenticate_user(email, password),
    {:ok, token, _claims} <- Guardian.encode_and_sign(user, %{}, ttl: {7, :days}) do
      conn
      |> put_status(:ok)
      |> render(:show, token: token, user: user)
    else
      {:error, :unauthorized} ->
        conn
        |> put_status(:unauthorized)
        |> render(NeumoApiWeb.ErrorView, :"401")
      {:error, _reason} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(NeumoApiWeb.ErrorView, :"422", message: "Invalid credentials")
    end
  end

  @doc """
  Handles user logout (revkes teh current token).
  Requires authentication.
  """
  def delete(conn, _params) do
    case Guardian.Plug.current_token(conn) do
      nil ->
        conn
        |> put_status(:unauthorized)
        |> render(NeumoApiWeb.ErrorView, :"401", message: "No token provided")
        token ->
          # Revoking the token to make it unusable for future requests.
          Guardian.revoke(token)
          conn
          |> put_status(:no_content)
          |> text("") #no content as the response.
    end
  end

  def render("show.json", %{token: token, user: user}) do
    %{
      data: %{
        user: %{id: user.id, email: user.email},
        token: token
      }
    }
  end
end
