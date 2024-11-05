defmodule FairDinkumWeb.PlayerLive.Show do
  @moduledoc false
  use FairDinkumWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Player <%= @player.id %>
      <:subtitle>This is a player record from your database.</:subtitle>

      <:actions>
        <.link patch={~p"/players/#{@player}/show/edit"} phx-click={JS.push_focus()}>
          <.button>Edit player</.button>
        </.link>
      </:actions>
    </.header>

    <.list>
      <:item title="Id"><%= @player.id %></:item>
    </.list>

    <.back navigate={~p"/players"}>Back to players</.back>

    <.modal
      :if={@live_action == :edit}
      id="player-modal"
      show
      on_cancel={JS.patch(~p"/players/#{@player}")}
    >
      <.live_component
        module={FairDinkumWeb.PlayerLive.FormComponent}
        id={@player.id}
        title={@page_title}
        action={@live_action}
        current_user={@current_user}
        player={@player}
        patch={~p"/players/#{@player}"}
      />
    </.modal>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:player, Ash.get!(FairDinkum.Players.Player, id, actor: socket.assigns.current_user))}
  end

  defp page_title(:show), do: "Show Player"
  defp page_title(:edit), do: "Edit Player"
end
