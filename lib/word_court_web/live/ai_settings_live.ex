defmodule WordCourtWeb.AISettingsLive do
  use WordCourtWeb, :live_view

  alias WordCourt.AISettings
  alias WordCourt.AISettings.Setting

  def mount(_params, _session, socket) do
    settings = AISettings.list_settings()

    # Create presets if none exist
    if Enum.empty?(settings) do
      AISettings.create_preset_configurations()
      settings = AISettings.list_settings()
    end

    {:ok, active_setting} = AISettings.get_active_setting()

    {:ok,
     socket
     |> assign(:settings, settings)
     |> assign(:active_setting, active_setting)
     |> assign(:editing_setting, nil)
     |> assign(:form, nil)
     |> assign(:show_form, false)}
  end

  def handle_event("new_setting", _params, socket) do
    changeset = AISettings.change_setting(%Setting{})

    {:noreply,
     socket
     |> assign(:editing_setting, %Setting{})
     |> assign(:form, to_form(changeset))
     |> assign(:show_form, true)}
  end

  def handle_event("edit_setting", %{"id" => id}, socket) do
    setting = AISettings.get_setting!(id)
    changeset = AISettings.change_setting(setting)

    {:noreply,
     socket
     |> assign(:editing_setting, setting)
     |> assign(:form, to_form(changeset))
     |> assign(:show_form, true)}
  end

  def handle_event("cancel_edit", _params, socket) do
    {:noreply,
     socket
     |> assign(:editing_setting, nil)
     |> assign(:form, nil)
     |> assign(:show_form, false)}
  end

  def handle_event("validate", %{"setting" => setting_params}, socket) do
    changeset =
      socket.assigns.editing_setting
      |> AISettings.change_setting(setting_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :form, to_form(changeset))}
  end

  def handle_event("save", %{"setting" => setting_params}, socket) do
    save_setting(socket, socket.assigns.editing_setting.id, setting_params)
  end

  def handle_event("activate_setting", %{"id" => id}, socket) do
    setting = AISettings.get_setting!(id)

    case AISettings.set_active_setting(setting) do
      {:ok, _} ->
        {:ok, active_setting} = AISettings.get_active_setting()

        {:noreply,
         socket
         |> assign(:active_setting, active_setting)
         |> put_flash(:info, "#{setting.name} is now the active configuration")}

      {:error, _} ->
        {:noreply, put_flash(socket, :error, "Failed to activate setting")}
    end
  end

  def handle_event("delete_setting", %{"id" => id}, socket) do
    setting = AISettings.get_setting!(id)

    if setting.is_preset do
      {:noreply, put_flash(socket, :error, "Cannot delete preset configurations")}
    else
      case AISettings.delete_setting(setting) do
        {:ok, _} ->
          settings = AISettings.list_settings()
          {:noreply, assign(socket, :settings, settings)}

        {:error, _} ->
          {:noreply, put_flash(socket, :error, "Failed to delete setting")}
      end
    end
  end

  defp save_setting(socket, nil, setting_params) do
    case AISettings.create_setting(setting_params) do
      {:ok, _setting} ->
        settings = AISettings.list_settings()

        {:noreply,
         socket
         |> assign(:settings, settings)
         |> assign(:editing_setting, nil)
         |> assign(:form, nil)
         |> assign(:show_form, false)
         |> put_flash(:info, "Setting created successfully")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  defp save_setting(socket, _id, setting_params) do
    case AISettings.update_setting(socket.assigns.editing_setting, setting_params) do
      {:ok, _setting} ->
        settings = AISettings.list_settings()

        {:noreply,
         socket
         |> assign(:settings, settings)
         |> assign(:editing_setting, nil)
         |> assign(:form, nil)
         |> assign(:show_form, false)
         |> put_flash(:info, "Setting updated successfully")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end
end
