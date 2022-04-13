defmodule BackendWeb.Router do
  use BackendWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug BackendWeb.Auth.Pipeline
    plug BackendWeb.Auth.CurrentUser
  end

  scope "/api", BackendWeb do
    pipe_through :api


    post "/users/signup", UserController, :create
    post "/users/signin", UserController, :signin

    resources "/users", UserController

    resources "/boards", BoardController
    get "/boards/userboards/:user_id", BoardController, :user_boards

    resources "/lists", ListController
    get "/lists/boardlists/:board_id", ListController, :board_lists

    resources "/tasks", TaskController
    get "/tasks/taskslist/:list_id", TaskController, :tasks_list

    resources "/board_permissions", BoardPermissionController, except: [:new, :edit, :show]
    get "/board_permissions/:board_id/user/:user_id", BoardPermissionController, :show
    get "/boards/:board_id/members", BoardPermissionController, :index

    resources "/comments", CommentController, except: [:new, :edit]
    get "/tasks/:task_id/comments", CommentController, :index

  end

  scope "/api", BackendWeb do
    pipe_through [:api, :auth]

  end




  pipeline :browser do
    plug(:accepts, ["html"])
  end

  scope "/", BackendWeb do
    pipe_through :browser
    get "/", DefaultController, :index


  end
  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: BackendWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
