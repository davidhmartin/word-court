defmodule WordCourtWeb.PageController do
  use WordCourtWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
