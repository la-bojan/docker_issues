defmodule FrontendWeb.Live.BoardLive.CommentForm do
  use Phoenix.LiveView
  import Phoenix.LiveView.Helpers

  alias FrontendWeb.Schemas.Comment
  alias FrontendWeb.Schemas.User
  alias FrontendWeb.Api.Comments
  alias FrontendWeb.Api.Users
  alias FrontendWeb.Api.Tasks


  @impl true
  def mount(_params, session, socket) do

    current_task = session["current_task"]
    current_user = session["current_user"]
    current_task_id = session["task_id"]
    access_token = session["access_token"]
    board_permission = session["board_permission"]
    params = %{"task_id" => current_task_id,"access_token" => access_token}


    {:ok,comments} = Comments.get_comments(params)
    socket =
      socket
      |> assign_defaults(session)
      |> assign(:current_task_id,current_task_id)
      |> assign(:comments, comments)
      |> assign(:current_task, current_task)
      |> assign(:current_user, current_user)
      |> assign(:board_permission,board_permission)

    {:ok, socket}
  end

  defp assign_defaults(socket, session) do


    {:ok,members} = Users.all_users(%{})

    socket
    |> assign(current_user: session["current_user"])
    |> assign(access_token: session["access_token"])
    |> assign(flash_message: nil)
    |> assign(board_id: session["board_id"])
    |> assign(members: members)
    |> assign(changeset: Comment.changeset(%Comment{}))
    |> assign(user_changeset: User.changeset(%User{}))
    |> assign(results: nil)
  end


  def render(assigns), do: Phoenix.View.render(FrontendWeb.CommentForm, "comment_form.html", assigns)

  def handle_event("add-new-comment", %{"comment" => comment_params}, socket) do

    params = Map.merge(%{"access_token" => socket.assigns.access_token }, comment_params)

    with {:ok, board} <- Comments.create_comment(params) do
      socket = put_flash(socket, :info, "Comment created successfully!")
      send(socket.parent_pid, :refresh_board)
      {:noreply, redirect(socket, socket)}
    else
      {:error,  %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: %{changeset | action: :create})}
      _error ->
        {:noreply,
        socket
        |> assign(changeset: Comment.create_changeset(%Comment{}, comment_params))}
    end
  end

  def handle_event("search_user", %{"user" => %{"email" => email } = _user} = _params, %{assigns: assigns} = socket) do
    users =
      Enum.filter(assigns.members,
        fn m ->
          String.contains?(m.email, email)
        end)
    socket =
      socket
      |> assign(search_query: email)
      |> assign(results: users)

    {:noreply, socket}
  end

  def handle_event("update_assignee", %{"assignee_id" => assignee_id}, %{assigns: assigns} = socket) do

    assignee_id = String.to_integer(assignee_id)
    params = %{"assignee_id" => assignee_id}

    params = Map.merge(%{"access_token" => assigns.access_token}, params)


    with {:ok, task} <- Tasks.update_task(assigns.current_task, params) do
      #send(socket.parent_pid, {:task_updated, task})
      send(socket.parent_pid, :refresh_board)
      socket =
        socket
        |> assign(edit_task: nil)
        |> assign(current_task_id: task.id)
        |> put_flash(:info, "Task updated successfully")
      {:noreply, socket}
    else
      _error ->
        {:noreply,
        socket
        |> put_flash(:error, "Unable to update task.")} #expand more on error handling
    end
  end

  def handle_event("delete-comment", %{"comment-id" => comment_id}, socket) do

    {:ok, _comment} = Comments.delete_comment(%{"id" => comment_id})

    send(socket.parent_pid, :comment_deleted)
    {:noreply, socket}
  end

  def handle_event("delete_assignee", %{"assignee_id" => assignee_id}, %{assigns: assigns} = socket) do

    assignee_id = String.to_integer(assignee_id)
    params = %{"assignee_id" => nil}

    params = Map.merge(%{"access_token" => assigns.access_token}, params)


    with {:ok, task} <- Tasks.update_task(assigns.current_task, params) do
      send(socket.parent_pid, :refresh_board)
      socket =
        socket
        |> assign(edit_task: nil)
        |> assign(current_task_id: task.id)
        |> put_flash(:info, "Task updated successfully")
      {:noreply, socket}
    else
      _error ->
        {:noreply,
        socket
        |> put_flash(:error, "Unable to update task.")} #expand more on error handling
    end
  end



end
