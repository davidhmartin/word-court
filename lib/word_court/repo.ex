defmodule WordCourt.Repo do
  use Ecto.Repo,
    otp_app: :word_court,
    adapter: Ecto.Adapters.SQLite3
end
