defmodule BackendWeb.ListView do
  use BackendWeb, :view
  alias BackendWeb.ListView
  alias BackendWeb.TaskView

  def render("index.json", %{lists: lists}) do
    render_many(lists, ListView, "list.json")
  end

  def render("show.json", %{list: list}) do
    render_one(list, ListView, "list.json")
  end

  def render("list.json", %{list: list}) do


    %{
      id: list.id,
      title: list.title,
      board_id: list.board_id,
      tasks: render_many(list.tasks, TaskView, "task.json")
    }


    Map.take(list, [:id, :title, :board_id])
    |> Map.merge(%{ tasks: render_many(list.tasks, TaskView, "task.json") })
  end
end
