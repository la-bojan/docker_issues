defmodule BackendWeb.TaskView do
  use BackendWeb, :view
  alias BackendWeb.TaskView

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
    :list_id
    ])
  end
end
