defmodule FrontendWeb.Live.BoardLive.TaskForm do
  use Phoenix.LiveView
  import Phoenix.LiveView.Helpers
  import FrontendWeb.TaskForm

  alias FrontendWeb.Schemas.Task

  alias FrontendWeb.Api.Tasks

  @impl true
  def mount(_params, session, socket) do
    {:ok, socket
    |> assign_defaults(session)}
  end


  def render(assigns), do: Phoenix.View.render(FrontendWeb.TaskForm, "task_form.html", assigns)

  def handle_event("add-new-task", %{"task" => task_params}, socket) do

    params = Map.merge(%{"access_token" => socket.assigns.access_token }, task_params)

    with {:ok, task} <- Tasks.create_task(params) do
      socket = put_flash(socket, :info, "Task created successfully!")
      send(socket.parent_pid, {:task_created, task})
      {:noreply, socket}
    else
      {:error,  %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: %{changeset | action: :create})}
      _error ->
        {:noreply,
        socket
        |> assign(changeset: Task.create_changeset(%Task{}, task_params))}
    end
  end

  defp assign_defaults(socket, session) do
    socket
    |> assign(current_user: session["current_user"])
    |> assign(access_token: session["access_token"])
    |> assign(flash_message: nil)
    |> assign(list_id: session["list_id"])
    |> assign(changeset: Task.changeset(%Task{}))
  end

end
