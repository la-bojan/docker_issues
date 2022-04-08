defmodule Backend.Boards.Boards do

  import Ecto.Query, warn: false
  alias Backend.Repo

  alias Backend.Boards.Board

  def list_boards do
    Repo.all(Board)
    |> Repo.preload(lists: [:tasks])
  end

  def get_board!(id),do: Repo.get!(Board, id)|> Repo.preload(lists: [:tasks])

  def create_board(attrs \\ %{}) do
    {:ok,board} = %Board{}
    |> Board.changeset(attrs)
    |> Repo.insert()

    {:ok, Repo.preload(board, lists: [:tasks])}
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
      from l in Board,
        where: l.user_id == ^user_id
    Repo.all(query)
    |>  Repo.preload(lists: [:tasks])
  end

end
