defmodule Backend.Accounts.Users do

  import Ecto.Query, warn: false
  alias Backend.Repo

  alias Backend.Accounts.User

  def list_users do
    Repo.all(User)
    |> Repo.preload(boards: [lists: [:tasks]])
  end

  def get_user!(id), do: Repo.get!(User, id)|> Repo.preload(boards: [lists: [:tasks]])

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, %User{} = user} -> {:ok, Repo.preload(user, boards: [lists: [:tasks]])}
      error -> error
    end
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end


  def get_by_email(email) do
    case Repo.get_by(User, email: email) |> Repo.preload(:boards) do
      nil ->
        {:error, :not_found}
      user ->
        {:ok, user}
    end
  end
end
