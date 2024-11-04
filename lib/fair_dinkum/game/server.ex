defmodule FairDinkum.Game.Server do
  @moduledoc """
  A GenServer that manages the lifecycle and state of an individual game instance.

  This module is responsible for:
  - Tracking players joining and leaving the game via Phoenix Presence
  - Handling incoming messages from players to advance game state
  - Maintaining game state according to the rules defined by a Rules module
  - Coordinating game flow between players

  The game's rules and state transitions are defined by a Rules behaviour module that is
  passed in when the server is started. This allows different game types to reuse the same
  server infrastructure while implementing their own specific game logic.
  """

  use GenServer

  alias FairDinkum.Game.Rules

  # Client
  def current_state(server_name) do
    GenServer.call(server_name, :current_state)
  end

  # Server
  @impl true
  @spec init(rules: module(), server_name: atom()) :: {:ok, Rules.game_state()} | {:stop, term()}
  def init(opts) do
    rules = Keyword.fetch!(opts, :rules)
    server_name = Keyword.fetch!(opts, :server_name)

    case rules.init(server_name) do
      {:ok, initial_state} ->
        {:ok, initial_state}

      {:error, reason} ->
        {:stop, reason}
    end
  end

  @impl true
  def handle_call({:response_received, response}, _from, state) do
    case state.rules.advance(state, response) do
      {:ok, new_state} ->
        {:reply, :ok, new_state}

      {:error, reason} ->
        {:reply, {:error, reason}, state}
    end
  end

  @impl true
  def handle_call(:current_state, _from, state) do
    {:reply, state, state}
  end
end
