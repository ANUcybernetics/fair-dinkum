defmodule FairDinkumWeb.LobbyLive do
  @moduledoc false
  use FairDinkumWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      {:ok, _} = FairDinkum.Presence.track(self(), "lobby", :rand.uniform(1000), %{name: "Barry"})
    end

    {:ok, assign(socket, page_title: "Game Lobby")}
  end

  @impl true
  def render(%{live_action: :index} = assigns) do
    ~H"""
    <div class="max-w-2xl mx-auto p-6">
      <h1 class="text-3xl font-bold mb-6">Fair Dinkum Game Lobby</h1>
    </div>
    """
  end
end
