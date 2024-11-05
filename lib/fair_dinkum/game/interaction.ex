defmodule FairDinkum.Game.Interaction do
  @moduledoc """
  This module is an interaction between one (or more) `Player`s, and the response will be a tuple.

  TODO better docs
  """
  defstruct [:player, :call, :response]

  @type t :: %__MODULE__{
          player: FairDinkum.Players.Player.t(),
          call: {:text, String.t()} | {:select, String.t(), list(String.t())} | {:error, term()},
          response: String.t()
        }
end
