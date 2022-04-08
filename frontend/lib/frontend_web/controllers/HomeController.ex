defmodule  FrontendWeb.HomeController do
  use FrontendWeb, :controller

  alias FrontendWeb.Api.Users


  def index(conn, _params) do

    conn =
      conn
        |> assign(:current_user, get_session(conn, :current_user))

    render(conn,"home.html")
  end


end
