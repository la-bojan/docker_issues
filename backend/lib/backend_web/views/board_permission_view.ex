defmodule BackendWeb.BoardPermissionView do
  use BackendWeb, :view
  alias BackendWeb.BoardPermissionView
  alias BackendWeb.UserView

  def render("index.json", %{board_permissions: board_permissions}) do
    render_many(board_permissions, BoardPermissionView, "board_permission.json")
  end

  def render("show.json", %{board_permission: board_permission}) do
    render_one(board_permission, BoardPermissionView, "board_permission.json")
  end

  def render("board_permission.json", %{board_permission: board_permission}) do
    %{
      id: board_permission.id,
      board_id: board_permission.board_id,
      user_id: board_permission.user_id,
      permission_type: board_permission.permission_type
    }

    Map.take(board_permission, [:id, :board_id, :user_id, :permission_type])
    |> Map.merge( %{user: render_one(board_permission.user, UserView, "user.json" )})

  end
end
