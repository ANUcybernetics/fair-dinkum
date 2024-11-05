defmodule FairDinkum.Presence do
  @moduledoc false
  use Phoenix.Presence, otp_app: :fair_dinkum, pubsub_server: FairDinkum.PubSub

  alias FairDinkum.Game.Server

  @impl true
  def init(_opts), do: {:ok, %{}}

  @impl true
  def handle_metas("server:" <> name_str, %{joins: joins, leaves: leaves}, _presences, state) do
    server_name = String.to_existing_atom(name_str)

    for {_, presence} <- joins do
      dbg()
      Server.send(server_name, {:player_joined, presence.player_id})
    end

    for {_, presence} <- leaves do
      dbg()
      Server.send(server_name, {:player_left, presence.player_id})
    end

    {:ok, state}
  end

  @impl true
  def handle_metas("lobby", %{joins: joins, leaves: leaves}, _presences, state) do
    for {player_id, _presence} <- joins do
      dbg()
    end

    for {player_id, _presence} <- leaves do
      dbg()
    end

    {:ok, state}
  end
end
