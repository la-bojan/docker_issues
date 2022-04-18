defmodule FrontendWeb.HomeView do
  use FrontendWeb, :view

  def extract_permission(user_id,board_permissions) do
    board_permission = Enum.find(board_permissions,nil, &(&1.user_id == user_id))
    if board_permission == nil do
      nil
    else
      board_permission.permission_type
    end
  end
end
