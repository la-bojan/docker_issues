defmodule FrontendWeb.Live.HomeLive.MemberForm do
  use Phoenix.LiveView
  import Phoenix.LiveView.Helpers
  import FrontendWeb.MemberForm

  alias FrontendWeb.Schemas.User
  alias FrontendWeb.Schemas.Board

  alias FrontendWeb.Api.BoardPermissions
  alias FrontendWeb.Api.Users

  @impl true
  def mount(_params, session, socket) do
    current_board_id = session["current_board_id"]
    access_token = session["access_token"]

    socket =
      socket
      |> assign_defaults(session)
      |> assign(:board_id,current_board_id)
      |> assign(:access_token,access_token)

    {:ok, socket}

  end


  def render(assigns), do: Phoenix.View.render(FrontendWeb.MemberForm, "member_form.html", assigns)


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

  def handle_event("select_permisson", %{"permisson" => permission}, %{assigns: assigns} = socket) do


    socket =
      socket
      |> assign(:permisson, permission)


    {:noreplay,socket}
  end

  def handle_event("craete_board_permission", %{"assignee_id" => assignee_id}, %{assigns: assigns} = socket) do

    assignee_id = String.to_integer(assignee_id)


    params = %{
      "user_id" => assignee_id,
      "board_id" => String.to_integer(assigns.board_id),
      "permission_type" => :read,
      "access_token" => socket.assigns.access_token
    }

    with {:ok, board_permission} <- BoardPermissions.create_board_permission(params) do
      board_permissions = assigns.board_permissions ++ [board_permission]
      members = assigns.members ++ [board_permission.user]
      #send(socket.parent_pid, {:task_updated, task})
      socket =
        socket
        |> assign(edit_task: nil)
        |> assign(:members, members)
        |> assign(:board_permissions, board_permissions)
        |> put_flash(:info, "Board permission created successfully")
      {:noreply, socket}
    else
      _error ->
        {:noreply,
        socket
        |> put_flash(:error, "Unable to create board permisson.")} #expand more on error handling
    end
  end



  defp assign_defaults(socket, session) do

    {:ok,members} = Users.all_users(%{})

    socket
    |> assign(current_user: session["current_user"])
    |> assign(access_token: session["access_token"])
    |> assign(members: members)
    |> assign(flash_message: nil)
    |> assign(user_changeset: User.changeset(%User{}))
    |> assign(results: nil)
    |> assign(:permisson, :manage)
  end
end
