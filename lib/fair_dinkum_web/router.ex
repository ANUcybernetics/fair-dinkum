defmodule FairDinkumWeb.Router do
  use FairDinkumWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {FairDinkumWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  live_session :default, on_mount: FairDinkumWeb.FetchPlayerID do
    scope "/", FairDinkumWeb do
      pipe_through :browser

      live "/", LobbyLive, :index
      live "/server/:server_name", GameLive, :index

      live "/players", PlayerLive.Index, :index
      live "/players/new", PlayerLive.Index, :new
      live "/players/:id/edit", PlayerLive.Index, :edit

      live "/players/:id", PlayerLive.Show, :show
      live "/players/:id/show/edit", PlayerLive.Show, :edit
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", FairDinkumWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:fair_dinkum, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: FairDinkumWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
