defmodule FrontendWeb.Live.HomeLive.Index do
  use Phoenix.LiveView
  import Phoenix.LiveView.Helpers

  alias FrontendWeb.Api.Users
  alias FrontendWeb.Api.Tasks
  alias FrontendWeb.Api.Lists
  alias FrontendWeb.Api.Boards
  alias FrontendWeb.Api.BoardPermissions

  @impl true
  def mount( _params,session, socket) do

    current_user = session["current_user"]
    {:ok,user} = Users.get_user(%{id: current_user})
    {:ok,boards} = Boards.get_user_boards(%{id: current_user})

    access_token = session["access_token"]

    socket =
      socket
      |> assign_defaults()
      |> assign(:user, user)
      |> assign(:boards,boards)
      |> assign(:current_user, current_user)
      |> assign(:access_token,access_token)

    {:ok, socket}
  end


  def assign_defaults(socket) do
    socket =
      socket
      |> assign(:current_list, nil)
      |> assign(:current_board, nil)
      |> assign(:current_modal, nil)
      |> assign(:current_user, nil)

  end

  def render(assigns) do
    FrontendWeb.HomeView.render("index.html", assigns)
  end



  def handle_info(:refresh_user,socket) do
    current_user = socket.assigns.current_user
    {:ok,user} = Users.get_user(%{id: current_user})

    socket =
      socket
      |> assign_defaults()
      |> assign(:user,user)

    {:noreply,socket}
  end


  def handle_event("new-board", %{"user-id" => user_id,"user-email" => user_email}, socket) do

    socket =
      socket
      |> assign(:current_user, user_id)
      |> assign(:current_user_email, user_email)
      |> assign(:current_modal, :board_form )
    {:noreply, socket}
  end


  def handle_event("add-new-member", %{"board-id" => board_id,"board-name" => board_name}, socket) do

    socket =
      socket
      |> assign(:current_board_id, board_id)
      |> assign(:current_board_name, board_name)
      |> assign(:current_modal, :add_new_member_form )
    {:noreply, socket}
  end


  def handle_event("close-modal", _params, socket) do

    socket =
      socket
      |> assign(:current_list, nil)
      |> assign(:current_list_title, nil)
      |> assign(:current_board, nil)
      |> assign(:current_board_name, nil)
      |> assign(:current_modal, nil )
    {:noreply, socket}
  end

  def handle_event("remove-member", %{"board-permission-id" => board_permission_id }, socket) do

    {:ok, _} = BoardPermissions.delete_board_permission(%{"id" => board_permission_id})

    current_user = socket.assigns.current_user
    {:ok,user} = Users.get_user(%{id: current_user})
    socket =
      socket
      |> assign_defaults()
      |> assign(:user,user)

    {:noreply,socket}
  end

  def handle_event("select_permission", params, socket) do

    permission = params["atom"]["permission"]
    socket =
      socket
      |> assign(:permission, String.to_atom(permission))


    {:noreply,socket}
  end

  def handle_event("delete-board", %{"id" => id}, socket) do


    {:ok, _} = Boards.delete_board(%{"id" => id})

    current_user = socket.assigns.current_user
    {:ok,user} = Users.get_user(%{id: current_user})

    socket =
      socket
      |> assign_defaults()
      |> assign(:user,user)

    {:noreply,socket}
  end

  def handle_event("show-board", %{"id" => id}, socket) do


    {:ok, _} = Boards.delete_board(%{"id" => id})

    current_user = socket.assigns.current_user
    {:ok,user} = Users.get_user(%{id: current_user})

    socket =
      socket
      |> assign_defaults()
      |> assign(:user,user)

    {:noreply,socket}
  end

  def handle_info(:board_permission_created, socket) do

    current_user = socket.assigns.current_user
    {:ok,user} = Users.get_user(%{id: current_user})

    socket =
      socket
      |> assign_defaults()
      |> assign(:user,user)

    {:noreply,socket}
  end




end
