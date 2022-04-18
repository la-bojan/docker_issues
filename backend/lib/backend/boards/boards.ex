defmodule Backend.Boards.Boards do

  import Ecto.Query, warn: false
  alias Backend.Repo

  alias Backend.Boards.Board
  alias Backend.Boards.BoardPermission

  def list_boards do
    Repo.all(Board)
    |> Repo.preload(:user)
    |> Repo.preload(lists: [tasks: [:assignee_user] ])
    |> Repo.preload(board_permissions: [:user])
  end

  def get_board!(id),do: Repo.get!(Board, id)|> Repo.preload(lists: [tasks: [:assignee_user]])  |> Repo.preload(:board_permissions)

  def create_board(attrs \\ %{}) do
    {:ok,board} = %Board{}
    |> Board.changeset(attrs)
    |> Repo.insert()

    {:ok, Repo.preload(board, lists: [:tasks])  |> Repo.preload(board_permissions: [:user])  }
  end

  def all_board_members(board_id) do
    query = from bp in BoardPermission,
      where: bp.board_id == ^board_id,
      preload: [:user]
    Repo.all(query)
  end

  def update_board(%Board{} = board, attrs) do
    board
    |> Board.changeset(attrs)
    |> Repo.update()
  end

  def delete_board(%Board{} = board) do
    Repo.delete(board)
  end

  def change_board(%Board{} = board, attrs \\ %{}) do
    Board.changeset(board, attrs)
  end

  def user_boards(user_id) do
    query =
      from b in Board,
      join: p in BoardPermission, on: b.id == p.board_id and p.user_id == ^user_id,
      select: b
    Repo.all(query)
    |>  Repo.preload( :user )
    |>  Repo.preload(lists: [:tasks])
    |>  Repo.preload( board_permissions: [:user] )
  end


  def list_boards_permission do
    Repo.all(BoardPermission)
    |> Repo.preload(:user)
  end

  def get_board_permission!(id), do: Repo.get!(BoardPermission, id)

  def get_board_permission!(id, preload) when is_list(preload), do: Repo.get!(BoardPermission, id) |>  Repo.preload( :user ) |> Repo.preload(preload)

  def get_board_permission!(board_id, user_id), do: Repo.get_by!(BoardPermission, [board_id: board_id, user_id: user_id])

  def create_board_permission(attrs \\ %{}) do

    %BoardPermission{}
    |> BoardPermission.changeset(attrs)
    |> Repo.insert()
  end

  def update_board_permission(%BoardPermission{} = permission, attrs) do
    permission
    |> BoardPermission.changeset(attrs)
    |> Repo.update()
  end

  def delete_board_permission(%BoardPermission{} = permission) do
    Repo.delete(permission)
  end

  def change_board_permission(%BoardPermission{} = permission, attrs \\ %{}) do
    BoardPermission.changeset(permission, attrs)
  end

end
