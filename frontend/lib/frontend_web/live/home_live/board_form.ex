defmodule FrontendWeb.Live.HomeLive.BoardForm do
  use Phoenix.LiveView
  import Phoenix.LiveView.Helpers
  import FrontendWeb.BoardForm

  alias FrontendWeb.Schemas.Board
  alias FrontendWeb.Api.Boards

  @impl true
  def mount(_params, session, socket) do
    {:ok, socket
      |> assign_defaults(session)}
  end


  def render(assigns), do: Phoenix.View.render(FrontendWeb.BoardForm, "board_form.html", assigns)


  def handle_event("add-new-board", %{"board" => board_params}, socket) do

    params = Map.merge(%{"access_token" => socket.assigns.access_token, "user_id" => socket.assigns.current_user }, board_params)


    with {:ok, board} <- Boards.create_board(params) do
      send(socket.parent_pid, :refresh_user)
      socket = put_flash(socket, :info, "Board created successfully!")
      {:noreply, socket}
    else
      {:error,  %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: %{changeset | action: :create})}
      _error ->
        {:noreply,
        socket
        |> assign(changeset: Board.create_changeset(%Board{}, board_params))}
    end

  end


  defp assign_defaults(socket, session) do
    socket
    |> assign(current_user: session["current_user"])
    |> assign(access_token: session["access_token"])
    |> assign(flash_message: nil)
    |> assign(changeset: Board.create_changeset(%Board{}))
  end
end
