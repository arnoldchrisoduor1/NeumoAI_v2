defmodule NeumoApi.Repo do
  use Ecto.Repo,
    otp_app: :neumo_api,
    adapter: Ecto.Adapters.Postgres
end
