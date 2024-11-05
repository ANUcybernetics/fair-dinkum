defmodule FairDinkum.Game.TwentyQs do
  @moduledoc false
  @behaviour FairDinkum.Game.Rules

  alias FairDinkum.Game.Interaction
  alias FairDinkum.Game.Server
  alias FairDinkum.Players.Player

  @impl true
  def init(_name, players) when length(players) < 2 do
    {:error, "need at least 2 players"}
  end

  @impl true
  def init(name, players) do
    # first player is the answerer (although could randomize if that was more fun)
    {answerer, questioners} = List.pop_at(players, 0)

    {:ok,
     %{
       server_name: name,
       questioners: questioners,
       answerer: answerer,
       progress: {:question, 0}
     }}
  end

  @impl true
  def advance(state), do: state

  @impl true
  def advance(%{answerer: %Player{id: answerer_id}, progress: {:question, question_number}} = state, interaction) do
    case interaction do
      # the interaction comes from the answerer
      %Interaction{responder_id: ^answerer_id, response: "yes"} ->
        questioner = Ash.get!(Player, interaction.caller_id)
        {:ok, %{state | progress: {:completed, "#{questioner.name} is the winner"}}}

      %Interaction{responder_id: ^answerer_id, response: "no"} ->
        questioners = rotate(state.questioners)
        [new_questioner | _] = questioners

        Server.send_to_player(
          state.server_name,
          new_questioner.id,
          {:text, "Ask a yes/no question about the the thing I'm thinking of"}
        )

        {:ok, %{state | progress: %{state | questioners: questioners, progress: {:question, question_number + 1}}}}

      # the interaction comes from a questioner
      %Interaction{response: question} ->
        Server.send_to_player(
          state.server_name,
          answerer_id,
          {:select, question, ["yes", "no"]}
        )

        {:ok, state}

      _ ->
        {:error, "invalid interaction"}
    end
  end

  @impl true
  def info do
    %{:name => "Twenty Questions"}
  end

  defp rotate([head | tail]), do: tail ++ [head]
end
