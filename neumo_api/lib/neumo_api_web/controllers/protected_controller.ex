defmodule NeumoApiWeb.ProtectedController do
  use NeumoApiWeb, :controller

  # we will add fallback crucial for handling authentication errors consistently
  action_fallback NeumoApiWeb.FallbackController

  def index(conn, _params) do
    user = Guardian.Plug.curremt_resource(con)

    conn
    |> put_status(:ok)
    |> render(:index, message: "Welcome, #{user.email}! You are authenticated")
  end

  def render("index.json", %{message: message}) do
    %{data: %{message: message}}
  end
end
