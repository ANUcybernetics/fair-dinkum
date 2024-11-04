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
        new_state =
          Map.put(
            changeset.data.state,
            Ash.Changeset.get_argument(changeset, :key),
            Ash.Changeset.get_argument(changeset, :value)
          )

        Ash.Changeset.force_change_attribute(
          changeset,
          :state,
          new_state
        )
      end
    end
  end
end
