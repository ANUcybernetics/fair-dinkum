defmodule FairDinkum.Players.Player do
  @moduledoc false
  use Ash.Resource,
    domain: FairDinkum.Players,
    data_layer: AshSqlite.DataLayer

  sqlite do
    table "players"
    repo FairDinkum.Repo
  end

  attributes do
    integer_primary_key :id
    attribute :name, :string
    attribute :type, :atom, default: :human
  end

  actions do
    defaults [:read]

    create :create do
      accept [:name, :type]
      primary? true
    end

    update :change_name do
      accept [:name]
    end
  end
end
