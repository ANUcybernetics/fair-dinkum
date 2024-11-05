defmodule FairDinkum.Presence do
  @moduledoc false
  use Phoenix.Presence, otp_app: :fair_dinkum, pubsub_server: FairDinkum.PubSub

  alias FairDinkum.Game.Server

  @impl true
  def init(_opts), do: {:ok, %{}}

  @impl true
  def handle_metas("server:" <> name_str, %{joins: joins, leaves: leaves}, _presences, state) do
    server_name = String.to_existing_atom(name_str)

    for {player_id, _presence} <- joins do
      Server.send(server_name, {:player_joined, player_id})
    end

    for {player_id, _presence} <- leaves do
      Server.send(server_name, {:player_left, player_id})
    end

    {:ok, state}
  end
end
