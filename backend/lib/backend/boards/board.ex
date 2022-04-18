defmodule Backend.Boards.Board do
  use Ecto.Schema
  import Ecto.Changeset
  alias Backend.Accounts.User
  alias Backend.Lists.List
  alias Backend.Lists.BoardPermission

  schema "boards" do
    field :name, :string
    belongs_to :user, User

    has_many :lists, List
    has_many :board_permissions, Backend.Boards.BoardPermission
    timestamps()
  end

  @doc false
  def changeset(board, attrs) do
    board
    |> cast(attrs, [:name,:user_id])
    |> cast_assoc(:lists, with: &List.changeset/2)
    |> cast_assoc(:board_permissions, with: &BoardPermission.changeset/2)
    |> validate_required([:name])
  end
end
