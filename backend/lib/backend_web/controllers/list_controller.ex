defmodule  BackendWeb.ListController do
  use BackendWeb, :controller

  alias Backend.Lists.Lists
  alias Backend.Lists.List

  def index(conn, _params) do
    lists = Lists.list_lists()

    render(conn, "index.json", lists: lists)
  end

  def create(conn, params) do
    list = Lists.create_list(params)
    {:ok,list} = list
    render(conn, "show.json", list: list)
  end

  def show(conn, %{"id" => id}) do
    list = Lists.get_list!(id)
    render(conn, "show.json", list: list)
  end

  def update(conn, %{"id" => id} = params) do
    list = Lists.get_list!(id)

    with {:ok, %List{} = list} <- Lists.update_list(list, params) do
      render(conn, "show.json", list: list)
    end
  end

  def delete(conn, %{"id" => id}) do
    list = Lists.get_list!(id)

    with {:ok, %List{}} <- Lists.delete_list(list) do
      send_resp(conn, :no_content, "")
    end
  end


  def board_lists(conn, %{"board_id" => board_id}) do
    lists = Lists.all_board_lists(board_id)

    render(conn, "index.json", lists: lists)
  end

end
