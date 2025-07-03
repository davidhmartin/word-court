defmodule WordCourt.Repo.Migrations.CreateAiSettings do
  use Ecto.Migration

  def change do
    create table(:ai_settings) do
      add :name, :string, null: false
      add :description, :text
      add :prosecutor_prompt, :text, null: false
      add :defender_prompt, :text, null: false
      add :judge_prompt, :text, null: false
      add :temperature, :float, default: 0.7
      add :max_tokens, :integer, default: 150
      add :model, :string, default: "gpt-3.5-turbo"
      add :is_active, :boolean, default: false
      add :is_preset, :boolean, default: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:ai_settings, [:name])
    create index(:ai_settings, [:is_active])
    create index(:ai_settings, [:is_preset])
  end
end
