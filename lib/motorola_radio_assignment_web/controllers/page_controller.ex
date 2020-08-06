defmodule MotorolaRadioAssignmentWeb.PageController do
  use MotorolaRadioAssignmentWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
