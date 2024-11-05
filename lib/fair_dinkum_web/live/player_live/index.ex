defmodule FairDinkumWeb.PlayerLive.Index do
  @moduledoc false
  use FairDinkumWeb, :live_view

  alias FairDinkum.Players.Player

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Listing Players
      <:actions>
        <.link patch={~p"/players/new"}>
          <.button>New Player</.button>
        </.link>
      </:actions>
    </.header>

    <.table
      id="players"
      rows={@streams.players}
      row_click={fn {_id, player} -> JS.navigate(~p"/players/#{player}") end}
    >
      <:col :let={{_id, player}} label="Id"><%= player.id %></:col>

      <:action :let={{_id, player}}>
        <div class="sr-only">
          <.link navigate={~p"/players/#{player}"}>Show</.link>
        </div>

        <.link patch={~p"/players/#{player}/edit"}>Edit</.link>
      </:action>
    </.table>

    <.modal
      :if={@live_action in [:new, :edit]}
      id="player-modal"
      show
      on_cancel={JS.patch(~p"/players")}
    >
      <.live_component
        module={FairDinkumWeb.PlayerLive.FormComponent}
        id={(@player && @player.id) || :new}
        title={@page_title}
        current_user={@current_user}
        action={@live_action}
        player={@player}
        patch={~p"/players"}
      />
    </.modal>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> stream(:players, Ash.read!(Player, actor: socket.assigns[:current_user]))
     |> assign_new(:current_user, fn -> nil end)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Player")
    |> assign(:player, Ash.get!(Player, id, actor: socket.assigns.current_user))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Player")
    |> assign(:player, nil)
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Players")
    |> assign(:player, nil)
  end

  @impl true
  def handle_info({FairDinkumWeb.PlayerLive.FormComponent, {:saved, player}}, socket) do
    {:noreply,
     socket
     |> push_event("store-player", %{id: player.id})
     |> stream_insert(:players, player)}
  end
end
