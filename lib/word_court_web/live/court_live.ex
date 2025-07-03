defmodule WordCourtWeb.CourtLive do
  use WordCourtWeb, :live_view

  alias WordCourt.AICourtroom

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:case_status, :idle)
     |> assign(:word, "")
     |> assign(:prosecutor_argument, "")
     |> assign(:defender_argument, "")
     |> assign(:judge_verdict, "")
     |> assign(:form, to_form(%{"word" => ""}))}
  end

  def handle_event("validate", %{"word" => word}, socket) do
    {:noreply, assign(socket, :form, to_form(%{"word" => word}))}
  end

  def handle_event("submit_word", %{"word" => word}, socket) do
    word = String.trim(word || "")

    if word != "" do
      send(self(), {:start_trial, word})

      {:noreply,
       socket
       |> assign(:case_status, :submitted)
       |> assign(:word, word)
       |> assign(:prosecutor_argument, "")
       |> assign(:defender_argument, "")
       |> assign(:judge_verdict, "")}
    else
      {:noreply, put_flash(socket, :error, "Please enter a word to dispute")}
    end
  end

  def handle_event("new_case", _params, socket) do
    {:noreply,
     socket
     |> assign(:case_status, :idle)
     |> assign(:word, "")
     |> assign(:prosecutor_argument, "")
     |> assign(:defender_argument, "")
     |> assign(:judge_verdict, "")
     |> assign(:form, to_form(%{"word" => ""}))}
  end

  def handle_info({:start_trial, word}, socket) do
    # Start the prosecution phase
    send(self(), {:get_prosecutor_argument, word})

    {:noreply, assign(socket, :case_status, :prosecution)}
  end

  def handle_info({:get_prosecutor_argument, word}, socket) do
    case AICourtroom.get_prosecutor_argument(word) do
      {:ok, argument} ->
        send(self(), {:get_defense_argument, word, argument})

        {:noreply,
         socket
         |> assign(:prosecutor_argument, argument)
         |> assign(:case_status, :defense)}

      {:error, reason} ->
        {:noreply,
         socket
         |> put_flash(:error, "Court error: #{reason}")
         |> assign(:case_status, :error)}
    end
  end

  def handle_info({:get_defense_argument, word, prosecutor_arg}, socket) do
    case AICourtroom.get_defense_argument(word) do
      {:ok, argument} ->
        send(self(), {:get_judge_verdict, word, prosecutor_arg, argument})

        {:noreply,
         socket
         |> assign(:defender_argument, argument)
         |> assign(:case_status, :judgment)}

      {:error, reason} ->
        {:noreply,
         socket
         |> put_flash(:error, "Court error: #{reason}")
         |> assign(:case_status, :error)}
    end
  end

  def handle_info({:get_judge_verdict, word, prosecutor_arg, defender_arg}, socket) do
    case AICourtroom.get_judge_verdict(word, prosecutor_arg, defender_arg) do
      {:ok, verdict} ->
        {:noreply,
         socket
         |> assign(:judge_verdict, verdict)
         |> assign(:case_status, :complete)}

      {:error, reason} ->
        {:noreply,
         socket
         |> put_flash(:error, "Court error: #{reason}")
         |> assign(:case_status, :error)}
    end
  end
end
