defmodule NeumoApi.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias NeumoApi.Accounts.User

  # Add these lines to match your migration's binary_id
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @derive {Jason.Encoder, only: [:id, :email]} # we will only encode these fields.

  schema "users" do
    field :email, :string
    field :password_hash, :string  # Changed from hashed_password to match migration
    field :password, :string, virtual: true, redact: true #for the input.
    field :password_confirmation, :string, virtual: true, redact: true # also only for the input.

    timestamps()
  end

  @doc """
  Changeset for registering a new user.
  """
  def registration_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :password, :password_confirmation])
    |> validate_required([:email, :password, :password_confirmation])
    |> validate_length(:password, min: 8)
    |> validate_confirmation(:password, message: "does not match password")
    |> validate_format(:email, ~r/@/, message: "must have @ sign")
    |> unique_constraint(:email)
    |> put_hashed_password()
  end

  @doc """
  Changeset for updating user details (e.g, email).
  """
  def user_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email])
    |> validate_required([:email])
    |> validate_format(:email, ~r/@/, message: "must have @ sign")
    |> unique_constraint(:email)
  end

  @doc """
  Changeset for updating password.
  """
  def password_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:password, :password_confirmation])
    |> validate_required([:password, :password_confirmation])
    |> validate_length(:password, min: 8)
    |> validate_confirmation(:password, message: "does not match password")
    |> put_hashed_password()
  end

  defp put_hashed_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password_hash, Pbkdf2.hash_pwd_salt(password))  # Changed field name
      _->
        changeset
    end
  end
end
