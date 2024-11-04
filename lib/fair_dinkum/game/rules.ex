defmodule FairDinkum.Game.Rules do
  @moduledoc """
  A behaviour that governs the rules of a game by defining how to initialize
  the game state and advance it from one state to the next.

  Any module implementing this behaviour can provide its own rules for managing
  game state transitions.

  The game state is a map with the following:

  - `:server_name` - the name of the server (a GenServer which will manage the specific game)
  - `:players` - a list of player structs
  - `:progress` - a tuple representing the current state of the game

  The game state can also contain any additional keys (because this behaviour is designed
  to be extended for the rules/state required by a specific game).

  """

  @type game_state() :: %{
          required(:server_name) => atom(),
          required(:players) => list(%FairDinkum.Players.Player{}),
          required(:progress) => tuple(),
          optional(atom()) => any()
        }

  @callback init(server_name :: atom()) ::
              {:ok, state :: game_state()}
              | {:error, reason :: term()}

  @callback add_player(id :: any()) ::
              {:ok, state :: game_state()}
              | {:error, reason :: term()}

  @callback remove_player(id :: any()) ::
              {:ok, state :: game_state()}
              | {:error, reason :: term()}

  @callback advance(state :: game_state()) ::
              {:ok, state :: game_state()}
              | {:error, reason :: term()}

  @callback add_bot(opts :: map()) ::
              {:ok, state :: game_state()}
              | {:error, reason :: term()}
end
