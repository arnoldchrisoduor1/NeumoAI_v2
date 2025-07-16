defmodule NeumoApiWeb.ErrorHelpers do
  @doc """
  Translates Ecto changeset errors to a map suitable for API responses.
  """
  def transalate_errors(changeset) do
    Ecto.Changeset.transverse_errors(changeset, fn {message, opts} ->
      Regex.replace(~r"%{(\w+)}", message, fn _, key ->
        opts |> Keyword.get(key, key) |> to_string
      end)
    end)
  end
end
