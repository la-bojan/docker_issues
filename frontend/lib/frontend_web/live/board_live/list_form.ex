defmodule FrontendWeb.Live.BoardLive.ListForm do
  use Phoenix.LiveView
  import Phoenix.LiveView.Helpers

  alias FrontendWeb.Schemas.List
  alias FrontendWeb.Api.Lists

  @impl true
  def mount(_params, session, socket) do
    {:ok, socket
    |> assign_defaults(session)}
  end


  def render(assigns), do: Phoenix.View.render(FrontendWeb.ListForm, "list_form.html", assigns)

  def handle_event("add-new-list", %{"list" => list_params}, socket) do

    params = Map.merge(%{"access_token" => socket.assigns.access_token }, list_params)

    with {:ok, list} <- Lists.create_list(params) do
      socket = put_flash(socket, :info, "List created successfully!")
      send(socket.parent_pid, {:list_created, list})
      {:noreply, socket}
    else
      {:error,  %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: %{changeset | action: :create})}
      _error ->
        {:noreply,
        socket
        |> assign(changeset: List.create_changeset(%List{}, list_params))}
    end
  end

  defp assign_defaults(socket, session) do
    socket
    |> assign(current_user: session["current_user"])
    |> assign(access_token: session["access_token"])
    |> assign(flash_message: nil)
    |> assign(board_id: session["board_id"])
    |> assign(changeset: List.changeset(%List{}))
  end

end
