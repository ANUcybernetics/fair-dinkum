defmodule FairDinkumWeb.FetchPlayerID do
  @moduledoc """
  If the player_id has been passed along (because it's already there in localstorage) then
  add it to assigns.
  """
  import Phoenix.Component
  import Phoenix.LiveView

  def on_mount(_, _params, _session, socket) do
    socket =
      case get_connect_params(socket)["playerId"] do
        nil ->
          socket

        player_id ->
          assign(socket, player_id: player_id)
      end

    {:cont, socket}
  end
end
