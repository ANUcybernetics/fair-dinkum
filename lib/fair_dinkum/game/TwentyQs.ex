defmodule FairDinkum.Game.TwentyQs do
  @moduledoc false
  @behaviour FairDinkum.Game.Rules

  alias FairDinkum.Players.Player

  @impl true
  def init(name) do
    {:ok,
     %{
       server_name: name,
       players: [],
       questioner: nil,
       progress: :waiting_for_players
     }}
  end

  @impl true
  def add_player(state, player) do
    case state do
      %{answerer: nil} ->
        {:ok, %{state | answerer: player}}

      # once there's a questioner, we can start
      %{questioners: questioners} ->
        {:ok, %{state | questioners: [player | questioners], progress: {:question, 0}}}

      _ ->
        {:error, :invalid_progress_state}
    end
  end

  @impl true
  def remove_player(state, %Player{id: id}) do
    case state do
      %{answerer: %Player{id: ^id}} ->
        {:error, :answerer_cannot_leave}

      %{players: players, questioners: questioners} = state ->
        {:ok,
         %{
           state
           | players: Enum.reject(players, &(&1.id == id)),
             questioners: Enum.reject(questioners, &(&1.id == id))
         }}
    end
  end

  @impl true
  def advance(%{progress: :waiting_for_players}) do
    {:error, "waiting for players"}
  end

  @impl true
  def advance(%{progress: :waiting_for_players}) do
    {:error, "waiting for players"}
  end

  @impl true
  def add_bot(_state, _opts) do
    {:error, :bots_not_supported}
  end
end
