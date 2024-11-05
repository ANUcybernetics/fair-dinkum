defmodule FairDinkum.Game.Rules do
  @moduledoc """
  A behaviour that governs the rules of a game by defining how to initialize
  the game state and advance it from one state to the next.

  Any module implementing this behaviour can provide its own rules for managing
  game state transitions.

  The game state is a map with the following:

  - `:server_name` - the name of the server (a GenServer which will manage the specific game)
  - `:players` - a list of player structs
  - `:progress` - tuple representing the current state of the game (type & value is game-dependent)

  The game state can also contain any additional keys (because this behaviour is designed
  to be extended for the rules/state required by a specific game).

  This behaviour also defines add_player/2, remove_player/2 and add_bot/2 callbacks for
  adding and removing players (because how they are added to the game state is also game-dependent)

  """

  alias FairDinkum.Players.Player

  @type game_state() :: %{
          required(:server_name) => atom(),
          required(:players) => list(%Player{}),
          required(:progress) => any(),
          optional(atom()) => any()
        }

  @callback init(server_name :: atom()) ::
              {:ok, state :: game_state()}
              | {:error, reason :: term()}

  @callback add_player(state :: game_state(), player :: Player.t()) ::
              {:ok, state :: game_state()}
              | {:error, reason :: term()}

  @callback remove_player(state :: game_state(), player :: Player.t()) ::
              {:ok, state :: game_state()}
              | {:error, reason :: term()}

  @callback advance(state :: game_state()) ::
              {:ok, state :: game_state()}
              | {:error, reason :: term()}

  @callback add_bot(state :: game_state(), opts :: map()) ::
              {:ok, state :: game_state()}
              | {:error, reason :: term()}
end
