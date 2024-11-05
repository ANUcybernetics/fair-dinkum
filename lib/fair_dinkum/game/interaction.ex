defmodule FairDinkum.Game.Interaction do
  @moduledoc """
  This module is an interaction between one (or more) `Player`s, and the response will be a tuple.

  TODO better docs
  """
  defstruct [:caller_id, :responder_id, :call, :response]

  @type t :: %__MODULE__{
          caller_id: integer(),
          responder_id: integer(),
          call: {:text, String.t()} | {:select, String.t(), list(String.t())} | {:error, term()},
          response: String.t()
        }
end
