defmodule FairDinkum.Players do
  @moduledoc false
  use Ash.Domain

  resources do
    resource FairDinkum.Players.Player do
      define :create, args: [:name, :type]
      define :change_name, args: [:name]
      define :put_state, args: [:key, :value]
    end
  end
end