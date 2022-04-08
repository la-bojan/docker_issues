defmodule BackendWeb.UserView do
  use BackendWeb, :view
  alias BackendWeb.UserView

  def render("index.json", %{users: users}) do
    render_many(users, UserView, "user.json")
  end

  def render("show.json", %{user: user}) do
    render_one(user, UserView, "user.json")
  end

  def render("user.json", %{user: user } = a ) do
    Map.take(user, [:id, :email])
    |> Map.merge(%{ boards: render_many(user.boards, BackendWeb.BoardView, "board.json") })
    |> Map.merge( %{ token: Map.get(a,:token) })

  end
end
