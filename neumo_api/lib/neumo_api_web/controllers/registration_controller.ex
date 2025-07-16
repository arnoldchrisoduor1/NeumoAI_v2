defmodule NeumoApiWeb.RegistrationController do
  use NeumoApiWeb, :controller

  alias NeumoApiWeb.Accounts

  action_fallback NeumoApiWeb.FallbackController

  def create(conn, %{"User" => user_params}) do
    with {:ok, user} <- Accounts.register_user(user_params) do
      conn
      |> put_status(:created)
      |> render(:show, user: user)
    end
  end

  def render("show.json", %{user: user}) do
    %{data: %{id: user.id, email: user.email}}
  end
end
