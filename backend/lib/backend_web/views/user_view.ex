defmodule BackendWeb.UserView do
  use BackendWeb, :view
  alias BackendWeb.UserView

  def render("index.json", %{users: users}) do
    render_many(users, UserView, "user.json")
  end

  def render("show.json", %{user: user}) do
    render_one(user, UserView, "user.json")
  end

  def render("user.json", %{user: user, token: token } = a ) do
    Map.take(user, [:id, :email])
    |> Map.put(:token, token)
  end

  def render("user.json", %{user: user } = a ) do
    Map.take(user, [:id, :email])
  end
end
