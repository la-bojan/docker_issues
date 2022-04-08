defmodule BackendWeb.BoardView do
  use BackendWeb, :view
  alias BackendWeb.BoardView
  alias BackendWeb.ListView

  def render("index.json", %{boards: boards}) do
    render_many(boards, BoardView, "board.json")
  end

  def render("show.json", %{board: board}) do
    render_one(board, BoardView, "board.json")
  end

  def render("board.json", %{board: board}) do
    %{
      id: board.id,
      name: board.name,
      user_id: board.user_id,
      lists: render_many(board.lists, BackendWeb.ListView, "list.json")
    }

    Map.take(board, [:id, :name, :user_id])
    |> Map.merge( %{lists: render_many(board.lists, ListView, "list.json" )})

  end
end
