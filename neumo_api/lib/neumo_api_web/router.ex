defmodule NeumoApiWeb.Router do
  use NeumoApiWeb, :router

  import Phoenix.Controller
  import Guardian.Plug

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Pipeline for the authenticated API requests.
  pipeline :api_auth do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader, claims: %{"type" => "access"}
    plug Guardian.Plug.LoadResource
    plug Guardian.Plug.EnsureAuthenticated
  end

  scope "/api", NeumoApiWeb do
    pipe_through :api

    # user registration.
    post "/register", RegistrationController, :create

    # User session.
    post "/login", SessionController, :create
    delete "/logout", SessionController, :delete, as: :session

    # our example protected route.
    scope "/protected" do
      pipe_through :api_auth
      get "/", ProtectedContoller, :index
    end
  end
end
