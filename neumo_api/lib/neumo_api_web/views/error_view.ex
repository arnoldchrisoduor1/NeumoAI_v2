defmodule NeumoApiWeb.ErrorView do
  use NeumoApiWeb, :view

  def render("401.json", _assigns) do
    %{errors: [%{status: "401", title: "Unauthorized", detail: "Authentication required or invalid credentials."}]}
  end

  def render("404.json", _assigns) do
    %{errors: [%{status: "401", title: "Not Found"}]}
  end

  def render("422.json", %{errors: changeset}) do
    %{errors: %{
      status: "422",
      title: "Unprocessable Entity",
      details: NeumoApiWeb.ErrorHelpers.transalate_errors(changeset)
    }}
  end

  def render("422.json", %{message: message}) do
    %{errors: [%{status: "422", title: "Unprocessable Entity", detail: message}]}
  end

  def render("500.json", _assign) do
    %{errrors: [%{status: "500", title: "Internal Server Error"}]}
  end

  def render("500.json", %{message: message}) do
    %{errors: [%{status: "500", title: "Internal Server Error", detail: message}]}
  end
end
