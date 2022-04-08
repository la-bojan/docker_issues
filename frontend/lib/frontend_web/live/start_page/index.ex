defmodule FrontendWeb.Live.StartPage.Index do
  use Phoenix.LiveView
  import Phoenix.LiveView.Helpers
  alias FrontendWeb.Router.Helpers, as: Routes

  alias FrontendWeb.Schemas.User
  alias FrontendWeb.Api.Users
  alias FrontendWeb.SessionController

  @impl true
  def mount(_params, _session, socket) do
    changeset = User.changeset(%User{})

    socket =
      socket
      |> assign(:changeset, changeset)

    {:ok, socket}
  end

  def render(assigns), do: Phoenix.View.render(FrontendWeb.StartPage, "start_page.html", assigns)

  def handle_event("save", %{"user" => user_params}, socket) do

    case SessionController.signin(socket,user_params) do
      {:ok, user} ->
        {:noreply,
         socket
         |> put_flash(:info, "user loged in #{user.email}" )
         |> redirect(to: "/home")}


      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def handle_event("signup", %{"user" => user_params}, socket) do

    case Users.create_user(user_params) do
      {:ok, user} ->
        {:noreply,
         socket
         |> put_flash(:info, "new account created!!!" )
         |> redirect(to: "/home")}


      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end


end
