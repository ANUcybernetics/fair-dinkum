defmodule FairDinkumWeb.LobbyLive do
  @moduledoc false
  use FairDinkumWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Game Lobby")}
  end

  @impl true
  def render(%{live_action: :index} = assigns) do
    ~H"""
    <div class="max-w-2xl mx-auto p-6">
      <h1 class="text-3xl font-bold mb-6">Fair Dinkum Game Lobby</h1>
      <ul class="space-y-4">
        <%= for server_name <- FairDinkum.GameSupervisor.server_names() do %>
          <li>
            <.link
              class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
              navigate={~p"/server/#{server_name}"}
            >
              Join <%= server_name %>
            </.link>
          </li>
        <% end %>
      </ul>
    </div>
    """
  end
end
