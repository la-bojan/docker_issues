defmodule BackendWeb.CommentView do
  use BackendWeb, :view
  alias BackendWeb.CommentView
  alias BackendWeb.ListView

  def render("index.json", %{comments: comments}) do
    render_many(comments, CommentView, "comment.json")
  end

  def render("show.json", %{comment: comment}) do
    render_one(comment, CommentView, "comment.json")
  end

  def render("comment.json", %{comment: comment}) do
    %{
      id: comment.id,
      content: comment.content,
      created_by_id: comment.created_by_id,
      inserted_at: comment.inserted_at,
      created_by_user: comment.created_by_user
    }
  end
end
