defmodule  BackendWeb.BoardController do
  use BackendWeb, :controller

  alias Backend.Boards.Boards
  alias Backend.Boards.Board

  def index(conn, _params) do


    boards = Boards.list_boards()

    render(conn, "index.json", boards: boards)
  end

  def create(conn, params) do

    {:ok,board} = Boards.create_board(params)
    board_permission_params = %{"board_id" => board.id, "user_id" => board.user_id, "permission_type" => :manage}
    {:ok,board_permission} = Boards.create_board_permission(board_permission_params)
    render(conn, "show.json", board: board)
  end

  def show(conn, %{"id" => id}) do
    board = Boards.get_board!(id)
    render(conn, "show.json", board: board)
  end

  def update(conn, %{"id" => id, "board" => board_params}) do
    board = Boards.get_board!(id)

    with {:ok, %Board{} = board} <- Boards.update_board(board, board_params) do
      render(conn, "show.json", board: board)
    end
  end

  def delete(conn, %{"id" => id}) do
    board = Boards.get_board!(id)

    with {:ok, %Board{}} <- Boards.delete_board(board) do
      send_resp(conn, :no_content, "")
    end
  end

  def user_boards(conn, %{"user_id" => user_id}) do
    boards = Boards.user_boards(user_id)

    render(conn, "index.json", boards: boards)
  end

end
