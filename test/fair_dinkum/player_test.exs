defmodule FairDinkum.PlayerTest do
  use FairDinkum.DataCase

  alias FairDinkum.Game
  alias FairDinkum.Game.Player

  describe "player" do
    test "creates with attributes" do
      {:ok, player} = Game.create_player("Test Player", :human)

      assert player.name == "Test Player"
      assert player.type == :human
      assert player.state == %{}
    end

    test "reads attributes" do
      {:ok, player} = Game.create_player("Test Player", :human)
      {:ok, read_player} = Ash.get(Player, player.id)

      assert read_player.id == player.id
      assert read_player.name == player.name
      assert read_player.type == player.type
      assert read_player.state == player.state
    end

    test "changes name" do
      {:ok, player} = Game.create_player("Original Name", :human)
      {:ok, updated_player} = Game.change_name(player.id, "New Name")

      assert updated_player.name == "New Name"
    end

    test "updates state" do
      {:ok, player} = Game.create_player("Test Player", :human)
      {:ok, updated_player} = Game.put_state(player.id, :score, 100)

      assert updated_player.state.score == 100
    end
  end
end
