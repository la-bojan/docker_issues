defmodule FrontendWeb.Live.BoardLive.CommentForm do
  use Phoenix.LiveView
  import Phoenix.LiveView.Helpers

  alias FrontendWeb.Schemas.Comment
  alias FrontendWeb.Api.Comments

  @impl true
  def mount(_params, session, socket) do

    current_task_id = session["current_task_id"]

    socket =
      socket
      |> assign_defaults(session)
      |> assign(:current_task_id,current_task_id)

    {:ok, socket}
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

  defp assign_defaults(socket, session) do
    socket
    |> assign(current_user: session["current_user"])
    |> assign(access_token: session["access_token"])
    |> assign(flash_message: nil)
    |> assign(board_id: session["board_id"])
    |> assign(changeset: Comment.changeset(%Comment{}))
  end

end
