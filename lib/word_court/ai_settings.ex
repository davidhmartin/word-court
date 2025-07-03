defmodule WordCourt.AISettings do
  @moduledoc """
  Context for managing AI courtroom settings and configurations.
  """

  import Ecto.Query, warn: false
  alias WordCourt.Repo
  alias WordCourt.AISettings.Setting

  @doc """
  Returns the list of ai settings.
  """
  def list_settings do
    Repo.all(Setting)
  end

  @doc """
  Gets a single setting.
  """
  def get_setting!(id), do: Repo.get!(Setting, id)

  @doc """
  Gets the active setting or creates a default one if none exists.
  """
  def get_active_setting do
    case Repo.one(from s in Setting, where: s.is_active == true) do
      nil -> create_default_setting()
      setting -> {:ok, setting}
    end
  end

  @doc """
  Creates a setting.
  """
  def create_setting(attrs \\ %{}) do
    %Setting{}
    |> Setting.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a setting.
  """
  def update_setting(%Setting{} = setting, attrs) do
    setting
    |> Setting.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a setting.
  """
  def delete_setting(%Setting{} = setting) do
    Repo.delete(setting)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking setting changes.
  """
  def change_setting(%Setting{} = setting, attrs \\ %{}) do
    Setting.changeset(setting, attrs)
  end

  @doc """
  Sets a setting as the active one, deactivating all others.
  """
  def set_active_setting(%Setting{} = setting) do
    Repo.transaction(fn ->
      # Deactivate all settings
      Repo.update_all(Setting, set: [is_active: false])

      # Activate the chosen setting
      setting
      |> Setting.changeset(%{is_active: true})
      |> Repo.update!()
    end)
  end

  @doc """
  Creates default preset configurations with individual agent settings.
  """
  def create_preset_configurations do
    presets = [
      %{
        name: "Professional Court",
        description: "Formal, by-the-book courtroom proceedings with balanced agents",
        prosecutor_prompt:
          "You are a strict prosecutor arguing that the word should be rejected. Be formal, cite dictionary standards, and argue based on traditional spelling and usage rules.",
        defender_prompt:
          "You are a defense attorney arguing that the word should be accepted. Be formal but creative, cite modern usage, etymology, and linguistic evolution.",
        judge_prompt:
          "You are a wise, impartial judge. Consider both arguments carefully and make a fair ruling based on lexicographical merit and common usage.",
        temperature: 0.5,
        max_tokens: 150,
        model: "gpt-3.5-turbo",
        # Individual agent settings for balanced professional court
        prosecutor_temperature: 0.3,
        defender_temperature: 0.6,
        judge_temperature: 0.4,
        prosecutor_max_tokens: 120,
        defender_max_tokens: 150,
        judge_max_tokens: 180,
        prosecutor_model: "gpt-3.5-turbo",
        defender_model: "gpt-3.5-turbo",
        judge_model: "gpt-4",
        is_preset: true
      },
      %{
        name: "Comedy Court",
        description: "Humorous and entertaining courtroom with highly creative agents",
        prosecutor_prompt:
          "You are a dramatic prosecutor who thinks this word is absolutely ridiculous. Be theatrical, use puns, and make humorous arguments while staying in character.",
        defender_prompt:
          "You are a witty defense attorney who loves wordplay. Defend this word with humor, clever arguments, and linguistic jokes.",
        judge_prompt:
          "You are a judge with a sense of humor. Make witty observations about both arguments before delivering an entertaining verdict.",
        temperature: 0.8,
        max_tokens: 200,
        model: "gpt-3.5-turbo",
        # Individual agent settings for comedy court - high creativity
        prosecutor_temperature: 0.9,
        defender_temperature: 0.9,
        judge_temperature: 0.8,
        prosecutor_max_tokens: 200,
        defender_max_tokens: 220,
        judge_max_tokens: 250,
        prosecutor_model: "gpt-3.5-turbo",
        defender_model: "gpt-3.5-turbo",
        judge_model: "gpt-3.5-turbo",
        is_preset: true
      },
      %{
        name: "Strict Academy",
        description: "Ultra-conservative dictionary purists with rigid consistency",
        prosecutor_prompt:
          "You are an extremely strict grammarian. Reject any word that isn't in the most traditional dictionaries. Be pedantic and uncompromising.",
        defender_prompt:
          "You are defending against extreme pedantry. Argue for linguistic evolution and practical usage, even against strict traditionalists.",
        judge_prompt:
          "You are a conservative judge who values traditional standards but recognizes some linguistic evolution. Be somewhat strict but fair.",
        temperature: 0.3,
        max_tokens: 120,
        model: "gpt-3.5-turbo",
        # Individual agent settings for strict academy - very low temperature
        prosecutor_temperature: 0.1,
        defender_temperature: 0.4,
        judge_temperature: 0.2,
        prosecutor_max_tokens: 100,
        defender_max_tokens: 140,
        judge_max_tokens: 120,
        prosecutor_model: "gpt-4",
        defender_model: "gpt-3.5-turbo",
        judge_model: "gpt-4",
        is_preset: true
      },
      %{
        name: "Wild West Court",
        description: "Unpredictable frontier justice with maximum creativity",
        prosecutor_prompt:
          "You are a frontier prosecutor in the Wild West. Be colorful, use Old West terminology, and argue with frontier passion and drama.",
        defender_prompt:
          "You are a charismatic defense attorney in the Old West. Use frontier charm, folksy wisdom, and creative arguments to defend your client's word.",
        judge_prompt:
          "You are a frontier judge dispensing justice in the Wild West. Be colorful, fair but unpredictable, and deliver verdicts with frontier flair.",
        temperature: 1.0,
        max_tokens: 180,
        model: "gpt-3.5-turbo",
        # Individual agent settings for wild west - maximum creativity
        prosecutor_temperature: 1.2,
        defender_temperature: 1.1,
        judge_temperature: 0.9,
        prosecutor_max_tokens: 200,
        defender_max_tokens: 200,
        judge_max_tokens: 220,
        prosecutor_model: "gpt-3.5-turbo",
        defender_model: "gpt-3.5-turbo",
        judge_model: "gpt-3.5-turbo",
        is_preset: true
      }
    ]

    Enum.each(presets, fn preset_attrs ->
      case Repo.get_by(Setting, name: preset_attrs.name) do
        nil -> create_setting(preset_attrs)
        _existing -> :ok
      end
    end)
  end

  defp create_default_setting do
    default_attrs = %{
      name: "Default Court",
      description: "Balanced courtroom proceedings",
      prosecutor_prompt:
        "You are a prosecutor arguing that this word should be rejected. Present your case clearly and professionally.",
      defender_prompt:
        "You are a defense attorney arguing that this word should be accepted. Present your case clearly and professionally.",
      judge_prompt: "You are an impartial judge. Consider both arguments and make a fair ruling.",
      temperature: 0.7,
      max_tokens: 150,
      model: "gpt-3.5-turbo",
      is_active: true
    }

    case create_setting(default_attrs) do
      {:ok, setting} -> {:ok, setting}
      {:error, _} -> {:error, "Could not create default setting"}
    end
  end
end
