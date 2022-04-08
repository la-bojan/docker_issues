defmodule FrontendWeb.Live.HomeLive.Index do
  use Phoenix.LiveView
  import Phoenix.LiveView.Helpers

  alias FrontendWeb.Api.Users
  alias FrontendWeb.Api.Tasks
  alias FrontendWeb.Api.Lists
  alias FrontendWeb.Api.Boards

  @impl true
  def mount( _params,session, socket) do

    current_user = session["current_user"]
    {:ok,user} = Users.get_user(%{id: current_user})

    socket =
      socket
      |> assign_defaults()
      |> assign(:user, user)
      |> assign(:current_user, current_user)

    {:ok, socket}
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

  def assign_defaults(socket) do
    socket =
      socket
      |> assign(:current_list, nil)
      |> assign(:current_board, nil)
      |> assign(:current_modal, nil)
      |> assign(:current_user, nil)

  end


end
