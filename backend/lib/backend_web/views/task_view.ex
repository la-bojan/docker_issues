defmodule BackendWeb.TaskView do
  use BackendWeb, :view
  alias BackendWeb.TaskView
  alias BackendWeb.UserView

  def render("index.json", %{tasks: tasks}) do
    render_many(tasks, TaskView, "task.json")
  end

  def render("show.json", %{task: task}) do
    render_one(task, TaskView, "task.json")
  end

  def render("task.json", %{task: task}) do
    task
    |> Map.take([
    :id,
    :title,
    :description,
    :position,
    :list_id,
    :assignee_id
    ])
    |> Map.merge( %{assignee: render_one(task.assignee_user, UserView, "user.json" )})
  end
end
