defmodule FrontendWeb.Live.BoardLive.ShowBoard do
  use Phoenix.LiveView
  import Phoenix.LiveView.Helpers
  alias FrontendWeb.Api.Users
  alias FrontendWeb.Api.Tasks
  alias FrontendWeb.Api.Lists


  @impl true
  def mount( _params,session, socket) do

    current_user = session["current_user"]
    current_board = session["current_board"]
    access_token = session["access_token"]
    {:ok,user} = Users.get_user(%{id: current_user})

    lists = current_board.lists

    socket =
      socket
      |> assign_defaults()
      |> assign(:user, user)
      |> assign(:current_user, current_user)
      |> assign(:current_board, current_board)
      |> assign(:access_token,access_token)
      |> assign(:lists, lists)

    {:ok, socket}
  end

  def render(assigns) do
    FrontendWeb.BoardView.render("board.html", assigns)
  end

  @impl true
  def handle_event("new-list", %{"board-id" => board_id,"board-name" => board_name}, socket) do
    socket =
        socket
        |> assign(:current_modal, :list_form)

    {:noreply, socket}
  end


  @impl true
  def handle_event("task-comments", %{"id" => id} = params, socket) do

    {:ok,current_task} = Tasks.get_task(params)

    socket =
        socket
        |> assign(:current_modal, :comment_form)
        |> assign(:current_task_id, id)
        |> assign(:current_task, current_task)

    {:noreply, socket}
  end

  def handle_info(:refresh_board,socket) do
    current_user = socket.assigns.current_user

    {:ok,user} = Users.get_user(%{id: current_user})

    socket =
      socket
      |> assign_defaults()
      |> assign(:user,user)

    {:noreply,socket}
  end

  def handle_info({ :list_created, list},socket ) do
    lists = socket.assigns.lists ++ [list]
    socket =
      socket
      |> assign(:lists,lists)
      |> assign(:current_modal, nil)

    {:noreply,socket}
  end

  def handle_event("new-task", %{"list-id" => list_id,"list-title" => list_title}, socket) do
    socket =
      socket
      |> assign(:add_to_list, String.to_integer(list_id))
      |> assign(:current_modal, :task_form )
    {:noreply, socket}
  end


  def handle_event(
    "reorder",
    %{"type" => "list", "resourceId" => list_id, "position" => position},
    %{assigns: assigns} = socket
  ) do

  list_id = String.to_integer(list_id)
  params = %{
    "access_token" => assigns.access_token,
    "position" => position
  }


  list = Enum.find(assigns.lists, &(&1.id == list_id))

  with {:ok, list} <- Lists.update_list(list, params) do
    lists =
      Enum.map(assigns.lists, fn l ->
        if l.id == list.id, do: list, else: l
      end)

    socket =
      socket
      |> put_flash(:info, "List reordered seccesufuly!")
      |> assign(modal: nil)
      |> assign(lists: lists)
    {:noreply, socket}
  else
    _error ->
      {:noreply, put_flash(socket, :error, "Unable to reorder list.")} #expand more on error handling
  end

  end


  def handle_event(
        "reorder",
        %{"type" => "task", "resourceId" => task_id, "position" => position, "sortableListId" => list_id},
        %{assigns: assigns} = socket
      ) do

    params = %{
      "access_token" => assigns.access_token,
      "list_id" => list_id,
      "position" => position
    }
    list_id = String.to_integer(list_id)
    task_id = String.to_integer(task_id)


    list = Enum.find(assigns.lists, &(&1.id == list_id))

    {:ok,task} = Tasks.get_task(%{"id" => task_id, "access_token" => assigns.access_token })

    with {:ok, task} <- Tasks.update_task(task, params) do
      tasks =
        Enum.map(list.tasks, fn t ->
          if t.id == task.id, do: task, else: t
        end)
      list = Map.put(list,:tasks,tasks)
      lists =
        Enum.map(assigns.lists, fn l ->
          if l.id == list.id, do: list, else: l
        end)

      socket =
        socket
        |> put_flash(:info, "Task reordered successfully")
        |> assign(modal: nil)
        |> assign(lists: lists)
      {:noreply, socket}
    else
      _error ->
        {:noreply, put_flash(socket, :error, "Unable to reorder task.")} #expand more on error handling
    end
    {:noreply,socket}
  end

  def handle_event("delete-task", %{"id" => id}, socket) do

    {:ok, _} = Tasks.delete_task!(%{"id" => id})

    socket =
      socket
      |> assign_defaults()

    {:noreply,socket}
  end

  def handle_event("delete-list", %{"id" => id}, socket) do

    {:ok, _} = Lists.delete_list(%{"id" => id})

    socket =
      socket
      |> assign_defaults()

    {:noreply,socket}
  end

  def handle_event("close-modal", _params, socket) do

    socket =
      socket
      |> assign(:current_modal, nil )
    {:noreply, socket}
  end

  def assign_defaults(socket) do
    socket =
      socket
      |> assign(:add_to_list, nil)
      |> assign(:current_modal, nil)
      |> assign(:current_user, nil)
      |> assign(:current_task, nil)


  end
end
