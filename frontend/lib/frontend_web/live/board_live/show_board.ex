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
    {:ok,user} = Users.get_user(%{id: current_user})

    socket =
      socket
      |> assign_defaults()
      |> assign(:user, user)
      |> assign(:current_user, current_user)
      |> assign(:current_board, current_board)

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

  def handle_info(:refresh_board,socket) do
    current_user = socket.assigns.current_user
    {:ok,user} = Users.get_user(%{id: current_user})

    socket =
      socket
      |> assign_defaults()
      |> assign(:user,user)

    {:noreply,socket}
  end

  def handle_event("new-task", %{"list-id" => list_id,"list-title" => list_title}, socket) do
    IO.puts("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
    IO.inspect(list_id)
    socket =
      socket
      |> assign(:add_to_list, String.to_integer(list_id))
      |> assign(:current_modal, :task_form )
    {:noreply, socket}
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


  end
end
