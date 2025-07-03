defmodule WordCourt.AICourtroom do
  @moduledoc """
  Handles AI-powered courtroom proceedings for word validation.
  """

  require Logger
  alias WordCourt.AISettings

  @doc """
  Gets a prosecutor's argument against the word.
  """
  def get_prosecutor_argument(word) do
    {:ok, setting} = AISettings.get_active_setting()

    prompt = String.replace(setting.prosecutor_prompt, "should", "\"#{word}\" should")

    agent_config = %{
      temperature: setting.prosecutor_temperature || setting.temperature,
      max_tokens: setting.prosecutor_max_tokens || setting.max_tokens,
      model: setting.prosecutor_model || setting.model
    }

    case make_openai_request(prompt, agent_config) do
      {:ok, response} ->
        {:ok, response}

      {:error, reason} ->
        Logger.warning("Prosecutor API error: #{inspect(reason)}, using mock response")
        {:ok, get_mock_prosecutor_argument(word)}
    end
  end

  @doc """
  Gets a defense attorney's argument for the word.
  """
  def get_defense_argument(word) do
    {:ok, setting} = AISettings.get_active_setting()

    prompt = String.replace(setting.defender_prompt, "should", "\"#{word}\" should")

    agent_config = %{
      temperature: setting.defender_temperature || setting.temperature,
      max_tokens: setting.defender_max_tokens || setting.max_tokens,
      model: setting.defender_model || setting.model
    }

    case make_openai_request(prompt, agent_config) do
      {:ok, response} ->
        {:ok, response}

      {:error, reason} ->
        Logger.warning("Defense API error: #{inspect(reason)}, using mock response")
        {:ok, get_mock_defense_argument(word)}
    end
  end

  @doc """
  Gets a judge's verdict based on both arguments.
  """
  def get_judge_verdict(word, prosecutor_argument, defense_argument) do
    {:ok, setting} = AISettings.get_active_setting()

    prompt = """
    #{setting.judge_prompt}

    The word in question is "#{word}".

    Prosecutor's argument: #{prosecutor_argument}

    Defense argument: #{defense_argument}

    Please provide your verdict.
    """

    agent_config = %{
      temperature: setting.judge_temperature || setting.temperature,
      max_tokens: setting.judge_max_tokens || setting.max_tokens,
      model: setting.judge_model || setting.model
    }

    case make_openai_request(prompt, agent_config) do
      {:ok, response} ->
        {:ok, response}

      {:error, reason} ->
        Logger.warning("Judge API error: #{inspect(reason)}, using mock response")
        {:ok, get_mock_judge_verdict(word)}
    end
  end

  defp make_openai_request(prompt, agent_config) do
    try do
      config = Application.get_env(:word_court, :openai)
      api_key = config[:api_key]

      if is_nil(api_key) or api_key == "" do
        Logger.warning("OpenAI API key not configured, using mock response")
        {:error, "API key not configured"}
      else
        headers = [
          {"Authorization", "Bearer #{api_key}"},
          {"Content-Type", "application/json"}
        ]

        body = %{
          model: agent_config.model,
          messages: [
            %{
              role: "user",
              content: prompt
            }
          ],
          max_tokens: agent_config.max_tokens,
          temperature: agent_config.temperature
        }

        Logger.info(
          "Making OpenAI API request with model: #{agent_config.model}, temp: #{agent_config.temperature}"
        )

        case Req.post("https://api.openai.com/v1/chat/completions",
               json: body,
               headers: headers,
               receive_timeout: 30_000
             ) do
          {:ok, %{status: 200, body: response}} ->
            content = get_in(response, ["choices", Access.at(0), "message", "content"])

            if content do
              Logger.info("OpenAI API success, response length: #{String.length(content)}")
              {:ok, content}
            else
              Logger.error("OpenAI API returned empty content")
              {:error, "Empty response content"}
            end

          {:ok, %{status: status, body: error_body}} ->
            Logger.error("OpenAI API error: #{status} - #{inspect(error_body)}")
            {:error, "API request failed with status #{status}"}

          {:error, reason} ->
            Logger.error("OpenAI API request failed: #{inspect(reason)}")
            {:error, reason}
        end
      end
    rescue
      exception ->
        Logger.error("Exception in OpenAI request: #{inspect(exception)}")
        {:error, "Request exception: #{inspect(exception)}"}
    catch
      kind, reason ->
        Logger.error("Caught error in OpenAI request: #{kind} - #{inspect(reason)}")
        {:error, "Request error: #{kind} - #{inspect(reason)}"}
    end
  end

  # Mock responses for when API is unavailable
  defp get_mock_prosecutor_argument(word) do
    "Your Honor, the word \"#{word}\" should be rejected as it lacks proper etymological foundation and violates traditional lexicographical standards."
  end

  defp get_mock_defense_argument(word) do
    "Your Honor, \"#{word}\" represents the natural evolution of language and should be embraced as a valid expression of modern communication."
  end

  defp get_mock_judge_verdict(word) do
    if String.length(word) > 6 do
      "After careful consideration, I find \"#{word}\" to be VALID. The defense presents compelling arguments for linguistic evolution."
    else
      "After reviewing both arguments, I must rule that \"#{word}\" is INVALID due to insufficient lexicographical merit."
    end
  end
end
