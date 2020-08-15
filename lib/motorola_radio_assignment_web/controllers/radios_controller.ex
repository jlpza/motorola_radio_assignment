defmodule MotorolaRadioAssignmentWeb.RadiosController do
  use MotorolaRadioAssignmentWeb, :controller

  alias MotorolaRadioAssignment.{Radio, Repo}

  def insert(conn, %{"id" => id, "alias" => radio_alias, "allowed_locations" => allowed_locations})
      when is_list(allowed_locations) do
    try do
      Repo.insert(%Radio{
          "id": elem(Integer.parse(id), 0),
          "alias": radio_alias,
          "allowed_locations": allowed_locations
      })
      conn |> send_resp(:ok, "")
    rescue
        Ecto.ConstraintError -> conn |> send_resp(:conflict, "The radio could not be created because a constraint was violated. Possibly the ID already exists.")
    end
  end

  def get_location(conn, %{"id" => id}) do
    conn |> send_resp(:not_found, "")
  end

  def post_location(conn, %{"id" => id}) do
    conn |> send_resp(:not_found, "")
  end

end
