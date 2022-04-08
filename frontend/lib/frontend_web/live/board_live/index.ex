defmodule FrontendWeb.Live.BoardLive.Index do
  use Phoenix.LiveView
  import Phoenix.LiveView.Helpers
  alias FrontendWeb.Api.Users

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
    FrontendWeb.BoardView.render("index.html", assigns)
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
