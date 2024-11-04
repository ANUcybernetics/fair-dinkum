defmodule FairDinkum.Repo do
  use Ecto.Repo,
    otp_app: :fair_dinkum,
    adapter: Ecto.Adapters.SQLite3
end
