defmodule FairDinkumWeb.GameLive do
  @moduledoc false
  use FairDinkumWeb, :live_view

  alias FairDinkum.Game.Server

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Game Lobby")}
  end

  @impl true
  def handle_params(%{"server_name" => server_name}, _uri, socket) do
    track(socket, server_name)
    {:noreply, assign(socket, :server_name, String.to_existing_atom(server_name))}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="max-w-2xl mx-auto p-6">
      <h1 class="text-3xl font-bold mb-6">
        <%= Server.game_info(@server_name) |> Map.get(:name) %> (<%= @server_name %>)
      </h1>
    </div>
    """
  end

  defp track(socket, server_name) do
    if connected?(socket) do
      {:ok, _} = FairDinkum.Presence.track(self(), "server:#{server_name}", :rand.uniform(1000), %{name: "Barry"})
    end
  end
end
