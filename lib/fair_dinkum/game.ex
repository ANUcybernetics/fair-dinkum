defmodule FairDinkum.Game do
  @moduledoc false
  use Ash.Domain

  resources do
    resource FairDinkum.Game.Player do
      define :create_player, args: [:name, :type], action: :create
      define :change_name, args: [:name]
      define :put_state, args: [:key, :value]
    end
  end
end
