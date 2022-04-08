defmodule  FrontendWeb.BoardController do
  use FrontendWeb, :controller

  alias FrontendWeb.Api.Boards


  def show(conn, params) do
    baord_id = params["id"]

    access_token = conn.assigns.access_token

    board_params = %{"id" => baord_id, "access_token" => access_token}

    {:ok,board} = Boards.get_board(board_params)

    conn =
      conn
        |> assign(:current_board, board)
    render(conn,"index.html")
  end


end
