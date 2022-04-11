defmodule Backend.Comments.Comments do
  import Ecto.Query, warn: false
  alias Backend.Repo

  alias Backend.Comments.Comment

  def all_comment do
    Repo.all(Comment)
  end

  def all_task_comments(task_id, preload) do
    query =
      from c in Comment,
        where: c.task_id == ^task_id,
        preload: ^preload
    Repo.all(query)
  end

  def get_comment!(id), do: Repo.get!(Comment, id)

  def get_comment!(id, preload), do: Repo.get!(Comment, id) |> Repo.preload(preload)

  def create_comment(attrs \\ %{}) do
    %Comment{}
    |> Comment.changeset(attrs)
    |> Repo.insert()
  end

  def update_comment(%Comment{} = comment, attrs) do
    comment
    |> Comment.changeset(attrs)
    |> Repo.update()
  end

  def delete_comment(%Comment{} = comment) do
    Repo.delete(comment)
  end

  def change_comment(%Comment{} = comment, attrs \\ %{}) do
    Comment.changeset(comment, attrs)
  end



end
