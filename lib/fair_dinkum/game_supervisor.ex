defmodule FairDinkum.GameSupervisor do
  @moduledoc false
  use Supervisor

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    children =
      Enum.map(server_names(), fn server_name ->
        Supervisor.child_spec(
          {FairDinkum.Game.Server, server_name: server_name, rules: FairDinkum.Game.TwentyQs},
          id: server_name
        )
      end)

    Supervisor.init(children, strategy: :one_for_one)
  end

  def server_names do
    [:group_1, :group_2, :group_3, :group_4, :group_5, :group_6]
  end
end
