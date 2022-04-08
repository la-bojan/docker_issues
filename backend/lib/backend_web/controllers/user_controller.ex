defmodule BackendWeb.UserController do
  use BackendWeb, :controller

  alias Backend.Accounts.Users
  alias Backend.Accounts.User
  alias BackendWeb.Auth.Guardian
  alias Backend.Repo


  action_fallback BackendWeb.FallbackController

  def index(conn, _params) do
    users = Users.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"email" => email, "password" => password} = user_params) do
    with {:ok, %User{} = user} <- Users.create_user(user_params),
    {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      conn
      |> put_status(:created)
      |> render("user.json", %{user: user, token: token})
    end
  end

  def signin(conn, %{"email" => email, "password" => password}) do
    with {:ok, user, token} <- Guardian.authenticate(email, password) do
      user = Repo.preload(user, boards: [lists: [:tasks]])
      conn
      |> put_status(:created)
      |> render("user.json", %{user: user, token: token})
    end
  end

  def login(conn, %{"user" => %{"username" => username, "password" => password}}) do
    Guardian.authenticate_user(username, password)
    |> login_reply(conn)
  end

  def show(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Users.get_user!(id)

    with {:ok, %User{} = user} <- Users.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  defp login_reply({:ok, user}, conn) do
    conn
    |> put_flash(:info, "Welcome back!")
    |> Guardian.Plug.sign_in(user)   #This module's full name is Auth.UserManager.Guardian.Plug,
    |> redirect(to: "/protected")    #and the arguments specified in the Guardian.Plug.sign_in()
  end                                #docs are not applicable here.



  def delete(conn, %{"id" => id}) do
    user = Users.get_user!(id)

    with {:ok, %User{}} <- Users.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end


end
