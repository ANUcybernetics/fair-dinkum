defmodule FairDinkum.Game.Player do
  @moduledoc false
  use Ash.Resource,
    domain: FairDinkum.Game,
    data_layer: AshSqlite.DataLayer

  sqlite do
    table "players"
    repo FairDinkum.Repo
  end

  attributes do
    integer_primary_key :id
    attribute :name, :string
    attribute :type, :atom

    # keys of this map must be atoms
    attribute :state, :map, default: %{}
  end

  actions do
    defaults [:read]

    create :create do
      accept [:name, :type]
    end

    update :change_name do
      accept [:name]
    end

    update :put_state do
      argument :key, :atom
      argument :value, :term

      change fn changeset, _context ->
        Ash.Changeset.change_attribute(changeset, :state, fn state ->
          Map.put(state, Ash.Changeset.get_argument(changeset, :key), Ash.Changeset.get_argument(changeset, :value))
        end)
      end
    end
  end
end
