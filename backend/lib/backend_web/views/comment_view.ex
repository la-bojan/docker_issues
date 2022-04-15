defmodule BackendWeb.CommentView do
  use BackendWeb, :view
  alias BackendWeb.CommentView
  alias BackendWeb.ListView
  alias BackendWeb.UserView

  def render("index.json", %{comments: comments}) do
    render_many(comments, CommentView, "comment.json")
  end

  def render("show.json", %{comment: comment}) do
    render_one(comment, CommentView, "comment.json")
  end

  def render("comment.json", %{comment: comment}) do
    comment
    |> Map.take([
      :id,
      :content,
      :created_by_id,
      :task_id,
      :inserted_at
    ])

    |> Map.merge( %{user: render_one(comment.created_by_user, UserView, "user.json" )})
  end
end
