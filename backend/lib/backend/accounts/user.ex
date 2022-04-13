defmodule Backend.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset


  schema "users" do
    field :email, :string
    field :encrypted_password, :string
    field :password, :string, virtual: true

    has_many :comments, Backend.Comments.Comment, foreign_key: :created_by_user_id
    has_many :assigned_tasks, Backend.Tasks.Item, foreign_key: :assignee_id
    has_many :board_permissions, Backend.Boards.BoardPermission
    has_many :boards, Backend.Boards.Board
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> validate_format(:email, ~r/^[A-Za-z0-9._-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/)
    |> validate_length(:password, min: 6)
    |> cast_assoc(:boards, with: &Board.changeset/2)
    |> unique_constraint(:email)
    |> put_hashed_password
  end

  defp put_hashed_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}}
        ->
          put_change(changeset, :encrypted_password, Comeonin.Bcrypt.hashpwsalt(password))
      _ ->
          changeset
    end
  end
end
