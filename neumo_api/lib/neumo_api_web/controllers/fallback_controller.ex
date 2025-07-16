defmodule NeumoApiWeb.FallbackController do
  use NeumoApiWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(NeumoApiWeb.ErrorView, :"422", errors: changeset)
  end

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:unauthorized)
    |> render(NeumoApiWeb.ErrorView, :"401")
  end

  # adding more error handling.
  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> render(NeumoApiWeb.ErrorView, :"404")
  end

  def call(conn, {error, message}) when is_binary(message) do
    conn
    |> put_status(:internal_server_error)
    |> render(NeumoApiWeb.ErrorView, :"500", message: message)
  end
end
