defmodule  FrontendWeb.SessionController do
  use FrontendWeb, :controller

  alias FrontendWeb.Api.Users
  alias FrontendWeb.Schemas.User


  def new(conn, _params) do
    conn
    |> assign(:access_token, nil)
    |> assign(:current_user, nil)

    render(conn, "signin.html")
  end


  def signin(conn, %{"user" => user}) do
    with {:ok,user} <- Users.signin_user(user) do
      conn = conn
      |> put_session(:access_token, user["token"])
      |> put_session(:current_user, user["id"])
      |> put_flash(:info, "Login successful")
      redirect(conn,to: Routes.home_path(conn,:index))
    else
      {:error,  %Ecto.Changeset{} = changeset  } ->
        conn
        |> assign(:access_token, nil)
        |> assign(:current_user, nil)
        |> assign(:changeset, %{changeset | action: :signin})
        redirect(conn,to: "/")
      _error ->
        conn
        |> assign(:access_token, nil)
        |> assign(:current_user, nil)
        |> put_flash(:error, "Email already taken.") #expand more on error handling
        redirect(conn,to: "/")
    end
  end

  def logout(conn, _params) do
    access_token = get_session(conn, :access_token)

    conn = update_in(conn.assigns, &Map.drop(&1, [:current_user]))

    conn
    |> delete_session(:access_token)
    |> delete_session(:current_user)
    |> put_flash(:info, "Logout Successful")
    |> redirect(to: "/")

  end
end
