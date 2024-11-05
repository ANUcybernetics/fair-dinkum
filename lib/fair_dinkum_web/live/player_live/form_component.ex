defmodule FairDinkumWeb.PlayerLive.FormComponent do
  @moduledoc false
  use FairDinkumWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>
          <%= case @form.source.type do %>
            <% :create -> %>
              Hi, friend! What name do you want to go by for this nonsense?
            <% :update -> %>
              So you want to change your name? No worries.
          <% end %>
        </:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="player-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <%= case @form.source.type do %>
          <% :create -> %>
            <.input field={@form[:name]} type="text" label="Name" />
          <% :update -> %>
            <.input field={@form[:name]} type="text" label="Name" />
        <% end %>

        <:actions>
          <.button phx-disable-with="Saving...">Let's go!</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_form()}
  end

  @impl true
  def handle_event("validate", %{"player" => player_params}, socket) do
    {:noreply, assign(socket, form: AshPhoenix.Form.validate(socket.assigns.form, player_params))}
  end

  def handle_event("save", %{"player" => player_params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.form, params: player_params) do
      {:ok, player} ->
        notify_parent({:saved, player})

        socket =
          socket
          |> put_flash(:info, "Player #{socket.assigns.form.source.type}d successfully")
          |> push_patch(to: socket.assigns.patch)

        {:noreply, socket}

      {:error, form} ->
        {:noreply, assign(socket, form: form)}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  defp assign_form(%{assigns: %{player: player}} = socket) do
    form =
      if player do
        AshPhoenix.Form.for_update(player, :change_name, as: "player", actor: socket.assigns.current_user)
      else
        AshPhoenix.Form.for_create(FairDinkum.Players.Player, :create, as: "player", actor: socket.assigns.current_user)
      end

    assign(socket, form: to_form(form))
  end
end
