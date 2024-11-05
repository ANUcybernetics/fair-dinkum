defmodule FairDinkum.Game.TwentyQs do
  @moduledoc false
  @behaviour FairDinkum.Game.Rules

  @impl true
  def init(_name, players) when length(players) < 2 do
    {:error, "need at least 2 players"}
  end

  @impl true
  def init(name, players) do
    {answerer, questioners} = List.pop_at(players, 0)

    {:ok,
     %{
       server_name: name,
       questioners: questioners,
       answerer: answerer,
       progress: {:question, 0}
     }}
  end

  @impl true
  def advance(%{progress: :waiting_for_players}) do
    {:error, "waiting for players"}
  end

  @impl true
  def advance(state, _interaction) do
    {:ok, state}
  end

  @impl true
  def info do
    %{:name => "Twenty Questions"}
  end
end
