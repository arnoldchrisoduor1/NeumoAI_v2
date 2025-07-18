defmodule NeumoApi.Accounts do
  import Ecto.Query, warn: false
  alias NeumoApi.Repo
  alias NeumoApi.Accounts.User

  @doc """
  Register a new user.
  """
  def register_user(attrs) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Authenticate a user by email and password.
  """
  def authenticate_user(email, password) do
    user = Repo.get_by(User, email: email)

    if user && Pbkdf2.verify_pass(password, user.password_hash) do  # Changed field name
      {:ok, user}
    else
      {:error, :unauthorized}
    end
  end

  @doc """
  Gets a user by Id.
  """
  def get_user(id) do
    Repo.get(User, id)
  end

  @doc """
  Gets a user by email
  """
  def get_user_by_email(email) do
    Repo.get_by(User, email: email)
  end
end
