defmodule WordCourt.Repo.Migrations.AddIndividualAgentSettings do
  use Ecto.Migration

  def change do
    alter table(:ai_settings) do
      # Individual temperature settings
      add :prosecutor_temperature, :float
      add :defender_temperature, :float
      add :judge_temperature, :float

      # Individual max tokens settings
      add :prosecutor_max_tokens, :integer
      add :defender_max_tokens, :integer
      add :judge_max_tokens, :integer

      # Individual model settings
      add :prosecutor_model, :string
      add :defender_model, :string
      add :judge_model, :string
    end
  end
end
