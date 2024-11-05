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

  alias FairDinkum.Game.Interaction
  alias FairDinkum.Game.Rules
  alias FairDinkum.Players.Player
  # alias Phoenix.Presence

  require Logger

  @type server_state() :: %{
          required(:rules) => module(),
          required(:players) => list(Player.t()),
          required(:pending_interactions) => %{integer() => Interaction.t()},
          # optional because on startup there's no game state yet
          optional(:game_state) => Rules.game_state()
        }

  def start_link(opts) do
    server_name = Keyword.fetch!(opts, :server_name)
    GenServer.start_link(__MODULE__, opts, name: server_name)
  end

  # Client
  def current_state(server_name) do
    GenServer.call(server_name, :current_state)
  end

  def game_info(server_name) do
    GenServer.call(server_name, :game_info)
  end

  def send_to_player(_server_name, player_id, interaction) do
    IO.puts("TODO: sending interaction to player #{player_id}: #{inspect(interaction)}")
    :ok
  end

  def send_to_all(_server_name, interaction) do
    IO.puts("TODO: sending interaction to all players: #{inspect(interaction)}")
    :ok
  end

  def send(server_name, interaction) do
    IO.puts("TODO: sending interaction to server #{server_name}: #{inspect(interaction)}")
    :ok
  end

  # Server
  @impl true
  @spec init(opts :: Keyword.t()) :: {:ok, server_state()} | {:stop, term()}
  def init(opts) do
    with {:ok, rules} <- Keyword.fetch(opts, :rules),
         {:ok, server_name} <- Keyword.fetch(opts, :server_name) do
      # no players or interactions at game startup
      {:ok, %{players: [], pending_interactions: %{}, rules: rules, server_name: server_name}}
    else
      :error -> {:stop, "missing required options: :rules, :server_name"}
    end
  end

  @impl true
  def handle_call({:response_received, interaction}, _from, state) do
    {:noreply,
     %{
       state
       | game_state: advance_game_state!(state, interaction),
         pending_interactions: Map.delete(state.pending_interactions, interaction.player)
     }}
  end

  @impl true
  def handle_call({:player_joined, player}, _from, state) do
    {:noreply, %{state | players: List.insert_at(state.players, -1, player)}}
  end

  @impl true
  def handle_call({:player_left, player}, _from, state) do
    Logger.warning("Player #{player.id} left the game... not handling this yet")
    {:noreply, %{state | players: Enum.reject(state.players, &(&1.id == player.id))}}
  end

  @impl true
  def handle_call(:current_state, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_call(:game_info, _from, state) do
    {:reply, state.rules.info(), state}
  end

  @impl true
  def handle_continue(_continue_arg, state) do
    {:noreply, advance_game_state!(state)}
  end

  defp advance_game_state!(state) do
    {:ok, next_game_state} = state.rules.advance(state.game_state)
    next_game_state
  end

  defp advance_game_state!(state, interaction) do
    {:ok, next_game_state} = state.rules.advance(state.game_state, interaction)
    next_game_state
  end
end
