defmodule WordCourt.AISettings.Setting do
  use Ecto.Schema
  import Ecto.Changeset

  schema "ai_settings" do
    field :name, :string
    field :description, :string
    field :prosecutor_prompt, :string
    field :defender_prompt, :string
    field :judge_prompt, :string
    field :temperature, :float, default: 0.7
    field :max_tokens, :integer, default: 150
    field :model, :string, default: "gpt-3.5-turbo"
    field :is_active, :boolean, default: false
    field :is_preset, :boolean, default: false

    # Individual agent settings
    field :prosecutor_temperature, :float
    field :defender_temperature, :float
    field :judge_temperature, :float
    field :prosecutor_max_tokens, :integer
    field :defender_max_tokens, :integer
    field :judge_max_tokens, :integer
    field :prosecutor_model, :string
    field :defender_model, :string
    field :judge_model, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(setting, attrs) do
    setting
    |> cast(attrs, [
      :name,
      :description,
      :prosecutor_prompt,
      :defender_prompt,
      :judge_prompt,
      :temperature,
      :max_tokens,
      :model,
      :is_active,
      :is_preset,
      :prosecutor_temperature,
      :defender_temperature,
      :judge_temperature,
      :prosecutor_max_tokens,
      :defender_max_tokens,
      :judge_max_tokens,
      :prosecutor_model,
      :defender_model,
      :judge_model
    ])
    |> validate_required([:name, :prosecutor_prompt, :defender_prompt, :judge_prompt])
    |> validate_length(:name, min: 1, max: 100)
    |> validate_length(:prosecutor_prompt, min: 10)
    |> validate_length(:defender_prompt, min: 10)
    |> validate_length(:judge_prompt, min: 10)
    |> validate_number(:temperature, greater_than_or_equal_to: 0.0, less_than_or_equal_to: 2.0)
    |> validate_number(:max_tokens, greater_than: 0, less_than_or_equal_to: 4000)
    |> validate_inclusion(:model, ["gpt-3.5-turbo", "gpt-4", "gpt-4-turbo"])
    |> validate_individual_agent_settings()
    |> unique_constraint(:name)
  end

  @doc """
  Validates individual agent settings with fallbacks to global settings.
  """
  defp validate_individual_agent_settings(changeset) do
    changeset
    |> validate_agent_temperature(:prosecutor_temperature)
    |> validate_agent_temperature(:defender_temperature)
    |> validate_agent_temperature(:judge_temperature)
    |> validate_agent_max_tokens(:prosecutor_max_tokens)
    |> validate_agent_max_tokens(:defender_max_tokens)
    |> validate_agent_max_tokens(:judge_max_tokens)
    |> validate_agent_model(:prosecutor_model)
    |> validate_agent_model(:defender_model)
    |> validate_agent_model(:judge_model)
  end

  defp validate_agent_temperature(changeset, field) do
    case get_field(changeset, field) do
      nil ->
        changeset

      temp ->
        validate_number(changeset, field,
          greater_than_or_equal_to: 0.0,
          less_than_or_equal_to: 2.0
        )
    end
  end

  defp validate_agent_max_tokens(changeset, field) do
    case get_field(changeset, field) do
      nil -> changeset
      tokens -> validate_number(changeset, field, greater_than: 0, less_than_or_equal_to: 4000)
    end
  end

  defp validate_agent_model(changeset, field) do
    case get_field(changeset, field) do
      nil -> changeset
      model -> validate_inclusion(changeset, field, ["gpt-3.5-turbo", "gpt-4", "gpt-4-turbo"])
    end
  end

  @doc """
  Returns available model options for select inputs.
  """
  def model_options do
    [
      {"GPT-3.5 Turbo (Fast & Affordable)", "gpt-3.5-turbo"},
      {"GPT-4 (Most Capable)", "gpt-4"},
      {"GPT-4 Turbo (Latest)", "gpt-4-turbo"}
    ]
  end

  @doc """
  Returns temperature descriptions for UI hints.
  """
  def temperature_description(temp) when is_float(temp) do
    cond do
      temp <= 0.3 -> "Conservative (consistent, predictable)"
      temp <= 0.7 -> "Balanced (creative yet reliable)"
      temp <= 1.0 -> "Creative (varied, imaginative)"
      true -> "Very Creative (highly unpredictable)"
    end
  end
end
