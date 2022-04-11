defmodule Backend.Boards.BoardPermission do
  use Ecto.Schema
  import Ecto.Changeset
  alias Backend.Accounts.User
  alias Backend.Boards.Board
  alias Backend.PermissionType

  schema "board_permissions" do
    field :permission_type, PermissionType
    belongs_to :board, Board
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(board_permission, attrs) do
    board_permission
    |> cast(attrs, [:permission_type, :user_id, :board_id])
    |> validate_required([:permission_type, :user_id, :board_id])
  end
end
