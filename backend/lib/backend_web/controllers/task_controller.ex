defmodule  BackendWeb.TaskController do
  use BackendWeb, :controller

  alias Backend.Tasks.Tasks
  alias Backend.Tasks.Item

  def index(conn, _params) do
    tasks = Tasks.list_tasks()

    render(conn, "index.json", tasks: tasks)
  end

  def create(conn, params) do
    {:ok,task} = Tasks.create_item(params)

    render(conn, "show.json", task: task)
  end

  def show(conn, %{"id" => id}) do
    task = Tasks.get_item!(id)
    render(conn, "show.json", task: task)
  end

  def update(conn, %{"id" => id} = params) do
    item = Tasks.get_item!(id)

    with {:ok, %Item{} = task} <- Tasks.update_item(item, params) do
      render(conn, "show.json", task: task)
    end
  end

  def tasks_list(conn, %{"list_id" => list_id}) do
    tasks = Tasks.all_list_tasks(list_id)

    render(conn, "index.json", tasks: tasks)
  end


  def delete(conn, %{"id" => id}) do
    item = Tasks.get_item!(id)

    with {:ok, %Item{}} <- Tasks.delete_item(item) do
      send_resp(conn, :no_content, "")
    end
  end


end
