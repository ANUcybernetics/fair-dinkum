defmodule FairDinkum.PlayerTest do
  use ExUnit.Case

  alias FairDinkum.Game.Player

  describe "player" do
    test "creates with attributes" do
      {:ok, player} = Api.create(Player, name: "Test Player", type: :human)

      assert player.name == "Test Player"
      assert player.type == :human
      assert player.state == %{}
    end

    test "reads attributes" do
      {:ok, player} = Api.create(Player, name: "Test Player", type: :human)
      {:ok, read_player} = Api.get(Player, player.id)

      assert read_player.id == player.id
      assert read_player.name == player.name
      assert read_player.type == player.type
      assert read_player.state == player.state
    end

    test "changes name" do
      {:ok, player} = Api.create(Player, name: "Original Name", type: :human)
      {:ok, updated_player} = Api.change_name(Player, player.id, name: "New Name")

      assert updated_player.name == "New Name"
    end

    test "updates state" do
      {:ok, player} = Api.create(Player, name: "Test Player", type: :human)
      {:ok, updated_player} = Api.put_state(Player, player.id, key: :score, value: 100)

      assert updated_player.state.score == 100
    end
  end
end
