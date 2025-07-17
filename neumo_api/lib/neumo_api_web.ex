defmodule NeumoApiWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, components, channels, and so on.

  This can be used in your application as:

      use NeumoApiWeb, :controller
      use NeumoApiWeb, :html

  The definitions below will be executed for every controller,
  component, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define additional modules and import
  those modules here.
  """
# alias ElixirLS.LanguageServer.Plugins.Phoenix

  def static_paths, do: ~w(assets fonts images favicon.ico robots.txt)

   def view do
    quote do
      use Phoenix.View,
        root: "lib/neumo_api_web/views",
        namespace: NeumoApiWeb

      # Importing convenience functions from controllers
      import Phoenix.Controller,
        only: [get_flash: 1, get_flash: 2, view_module: 1, view_template: 1]

      # Including shared imports and aliases for views
      unquote(view_helpers())
    end
  end

  defp view_helpers do
    quote do
      # Add shared imports/aliases here
      import Phoenix.View
      import NeumoApiWeb.ErrorHelpers
      import NeumoApiWeb.Gettext
      alias NeumoApiWeb.Router.Helpers, as: Routes
    end
  end


  def router do
    quote do
      use Phoenix.Router, helpers: false

      # Import common connection and controller functions to use in pipelines
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
    end
  end

  def controller do
    quote do
      use Phoenix.Controller,
        formats: [:html, :json],
        layouts: [html: NeumoApiWeb.Layouts]

      import Plug.Conn
      import NeumoApiWeb.Gettext

      unquote(verified_routes())
    end
  end

  def verified_routes do
    quote do
      use Phoenix.VerifiedRoutes,
        endpoint: NeumoApiWeb.Endpoint,
        router: NeumoApiWeb.Router,
        statics: NeumoApiWeb.static_paths()
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/live_view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
